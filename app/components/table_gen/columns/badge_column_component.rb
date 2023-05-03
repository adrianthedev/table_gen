# frozen_string_literal: true

module TableGen
  module Columns
    class BadgeColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, flush: true) do
          render TableGen::Columns::Common::BadgeViewerComponent.new(
            value: @column.value,
            options: @column.options
          )
        end
      end
    end
  end
end
