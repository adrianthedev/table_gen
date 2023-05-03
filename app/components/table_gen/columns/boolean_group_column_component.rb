# frozen_string_literal: true

module TableGen
  module Columns
    class BooleanGroupColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, dash_if_blank: false) do
          render TableGen::Columns::Common::BooleanGroupComponent.new options: @column.options, value: @column.value
        end
      end
    end
  end
end
