# frozen_string_literal: true

module TableGen
  module Columns
    class ProgressBarColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, flush: true) do
          render TableGen::Columns::Common::ProgressBarComponent.new(
            value: @column.value,
            display_value: @column.display_value,
            value_suffix: @column.value_suffix,
            max: @column.max
          )
        end
      end
    end
  end
end
