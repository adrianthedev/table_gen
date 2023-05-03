# frozen_string_literal: true

module TableGen
  module Columns
    class TextColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          if @column.as_html
            @column.value
          elsif @column.protocol.present?
            link_to @column.value, "#{@column.protocol}:#{@column.value}"
          else
            link_to_if @column.link_to_table, @column.value, table_view_path
          end
        end
      end
    end
  end
end
