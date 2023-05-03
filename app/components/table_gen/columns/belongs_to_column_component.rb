# frozen_string_literal: true

module TableGen
  module Columns
    class BelongsToColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          link_to @column.label, table_view_path(model: @column.value, table: @column.target_table)
        end
      end
    end
  end
end
