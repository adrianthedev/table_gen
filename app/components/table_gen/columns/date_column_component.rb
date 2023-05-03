# frozen_string_literal: true

module TableGen
  module Columns
    class DateColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          content_tag :div, @column.formatted_value, data: {
            controller: 'date-column',
            date_column_format_value: @column.format,
            date_column_column_type_value: 'date'
          }
        end
      end
    end
  end
end
