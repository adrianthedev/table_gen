require "dry-initializer"

# This object holds some data that is usually needed to compute blocks around the app.
module TableGen
  module Hosts
    class BaseHost
      extend Dry::Initializer

      option :context, default: proc { TableGen::App.context }
      option :params, default: proc { TableGen::App.params }
      option :view_context, default: proc { TableGen::App.view_context }
      option :current_user, default: proc { TableGen::App.current_user }
      option :main_app, default: proc { view_context.main_app }
      # This is optional because we might instantiate the `Host` first and later hydrate it with a block.
      option :block, optional: true

      delegate :authorize, to: TableGen::Services::AuthorizationService

      def handle
        instance_exec(&block)
      end
    end
  end
end
