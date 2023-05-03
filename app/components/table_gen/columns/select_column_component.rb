# frozen_string_literal: true

module TableGen
  module Columns
    class SelectColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          @column.label
        end
      end
    end
  end
end
