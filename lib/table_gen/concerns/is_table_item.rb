# This concern helps us figure out what kind of items (column, tool, tab_group, or panel) have been passed to the table or action.
module TableGen
  module Concerns
    module IsTableItem
      extend ActiveSupport::Concern

      included do
        class_attribute :item_type, default: nil
      end

      def is_column?
        self.class.item_type == :column
      end

      def is_tool?
        self.class.item_type == :tool
      end
    end
  end
end
