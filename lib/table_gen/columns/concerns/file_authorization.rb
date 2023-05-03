module TableGen
  module Columns
    module Concerns
      module FileAuthorization
        extend ActiveSupport::Concern

        delegate :authorization, to: :@table
        delegate :authorize_action, to: :authorization
        delegate :id, :model, to: :@column

        def can_upload_file?
          authorize_file_action(:upload)
        end

        def can_delete_file?
          authorize_file_action(:delete)
        end

        def can_download_file?
          authorize_file_action(:download)
        end

        private

        def authorize_file_action(action)
          authorize_action("#{action}_attachments?", raise_exception: false) || authorize_action("#{action}_#{id}?", record: model, raise_exception: false)
        end
      end
    end
  end
end
