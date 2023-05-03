# frozen_string_literal: true

module TableGen
  module Columns
    class NumberColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          @column.value
        end
      end
    end
  end
end
