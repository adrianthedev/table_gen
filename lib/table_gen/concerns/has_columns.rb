# frozen_string_literal: true

module TableGen
  module Concerns
    module HasColumns
      extend ActiveSupport::Concern

      included do
        class_attribute :items_holder
        class_attribute :items_index, default: 0
        class_attribute :tools_holder
      end

      class_methods do
        # DSL methods
        def column(name, **args, &block)
          ensure_items_holder_initialized
          items_holder.column name, **args, &block
        end

        def tool(klass, **args)
          ensure_items_holder_initialized
          items_holder.tool klass, **args
        end

        # END DSL methods

        def items
          items_holder&.items || []
        end

        def tools
          tools_holder || []
        end

        # Dives deep into panels and tabs to fetch all the columns for a table.
        def columns
          items.compact.select(&:is_column?).flatten
        end

        private

        def ensure_items_holder_initialized
          self.items_holder ||= TableGen::ItemsHolder.new
        end

        def increment_order_index
          self.items_index += 1
        end
      end

      delegate :invalid_columns, :items, to: :items_holder

      def hydrate_columns(model: nil)
        columns.map { |column| column.hydrate(model: model, table: self) }
        self
      end

      def columns(**args)
        self.class.columns(**args)
      end

      def column_definitions
        columns.map { |column| column.hydrate(table: self, user: user) }
      end

      def get_columns
        column_definitions.tap { hydrate_columns(model: @model) }
      end

      def tools
        items.compact.select(&:is_tool?)
      end
    end
  end
end
