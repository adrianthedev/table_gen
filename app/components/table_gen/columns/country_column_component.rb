# frozen_string_literal: true

module TableGen
  module Columns
    class CountryColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          if @column.display_code
            @column.value
          else
            @column.countries[@column.value]
          end
        end
      end
    end
  end
end
