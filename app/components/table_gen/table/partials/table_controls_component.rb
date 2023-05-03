# frozen_string_literal: true

module TableGen
  module Table
    module Partials
      # test
      class TableControlsComponent < TableGen::BaseTableComponent
        def initialize(table: nil)
          super
          @table = table
        end

        def edit_path
          url_for(edit_path_args)
        end

        def view_path
          url_for(view_path_args)
        end

        def can_edit?
          can_authorize?(:edit)
        end

        def can_view?
          can_authorize?(:show)
        end

        def can_delete?
          can_authorize?(:destroy)
        end

        def referrer_path
          TableGen::App.root_path(
            paths: ['tables', params[:table_name], params[:id], params[:related_name]],
            query: request.query_parameters.to_h
          )
        end

        private

        def edit_path_args
          [:edit, *@table.namespace, @table.model]
        end

        def view_path_args
          [*@table.namespace, @table.model]
        end

        def can_authorize?(action)
          @table.authorization.authorize_action(action, raise_exception: false)
        end
      end
    end
  end
end
