# frozen_string_literal: true

module TableGen
  module Columns
    class StatusColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          render TableGen::Columns::Common::StatusViewerComponent.new label: @column.value, status: @column.status
        end
      end
    end
  end
end
