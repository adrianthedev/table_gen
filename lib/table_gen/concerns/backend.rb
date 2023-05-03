module TableGen
  module Concerns
    module Backend
      extend ActiveSupport::Concern

      included do
        include TableGen::ApplicationHelper
        include TableGen::UrlHelpers

        before_action :init_app
        before_action :_authenticate!

        rescue_from TableGen::NotAuthorizedError, with: :render_unauthorized
        rescue_from ActiveRecord::RecordInvalid, with: :exception_logger

        helper_method :_current_user

        add_flash_types :info, :warning, :success, :error
      end

      def init_app
        TableGen::App.init(
          request: request,
          context: context,
          current_user: _current_user,
          view_context: view_context,
          params: params
        )
      end

      def exception_logger(exception)
        respond_to do |format|
          format.html { raise exception }
          format.json do
            render json: {
              errors: exception.respond_to?(:record) && exception.record.present? ? exception.record.errors : [],
              message: exception.message,
              traces: exception.backtrace
            }, status: ActionDispatch::ExceptionWrapper.status_code_for_exception(exception.class.name)
          end
        end
      end

      def _current_user
        instance_eval(&TableGen.configuration.current_user)
      end

      def context
        instance_eval(&TableGen.configuration.context)
      end

      private

      def _authenticate!
        instance_eval(&TableGen.configuration.authenticate)
      end

      def render_unauthorized(_exception)
        flash[:notice] = t 'avo.not_authorized'

        redirect_url = if request.referrer.blank? || (request.referrer == request.url)
                         root_url
                       else
                         request.referrer
                       end

        redirect_to redirect_url
      end
    end
  end
end
