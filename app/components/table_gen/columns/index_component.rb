# frozen_string_literal: true

module TableGen
  module Columns
    class IndexComponent < ViewComponent::Base
      include Turbo::FramesHelper
      include TableGen::ApplicationHelper
      include TableGen::TablesHelper

      def initialize(column: nil, table: nil, index: 0)
        super
        @column = column
        @table = table
        @index = index
      end

      def table_view_path
        root_path
        # helpers.table_view_path(model: @table.model, table: parent_or_child_table, **args)
      end

      def column_wrapper_args
        {
          column: @column,
          table: @table
        }
      end
    end
  end
end
