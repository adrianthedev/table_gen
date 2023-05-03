# frozen_string_literal: true

require 'dry-initializer'

# This object holds some data tha is usually needed to compute blocks around the app.
module TableGen
  module Tables
    module Controls
      class ExecutionContext
        extend Dry::Initializer

        option :context, default: proc { TableGen::App.context }
        option :params, default: proc { TableGen::App.params }
        option :view_context, default: proc { TableGen::App.view_context }
        option :current_user, default: proc { TableGen::App.current_user }
        option :items_holder, default: proc { TableGen::Tables::Controls::ItemsHolder.new }
        option :table, optional: true
        option :record, optional: true
        option :block, optional: true

        delegate :authorize, to: TableGen::Services::AuthorizationService

        def handle
          instance_exec(&block)
        end

        private

        def delete_button(**args)
          items_holder.add_item TableGen::Tables::Controls::DeleteButton.new(**args)
        end

        def edit_button(**args)
          items_holder.add_item TableGen::Tables::Controls::EditButton.new(**args)
        end

        def link_to(label, path, **args)
          items_holder.add_item TableGen::Tables::Controls::LinkTo.new(label: label, path: path, **args)
        end

        def actions_list(**args)
          items_holder.add_item TableGen::Tables::Controls::ActionsList.new(**args)
        end

        def action(klass, **args)
          items_holder.add_item TableGen::Tables::Controls::Action.new(klass, record: record, table: table, **args)
        end
      end
    end
  end
end
