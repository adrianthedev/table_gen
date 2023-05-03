# frozen_string_literal: true

module TableGen
  module Columns
    class TimeColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          content_tag :div, @column.formatted_value, data: {
            controller: "date-column",
            date_column_enable_time_value: true,
            date_column_format_value: @column.format,
            date_column_timezone_value: @column.timezone,
            date_column_picker_format_value: @column.picker_format,
            date_column_no_calendar_value: true,
            date_column_relative_value: @column.relative,
            date_column_column_type_value: "time",
          }
        end
      end
    end
  end
end
