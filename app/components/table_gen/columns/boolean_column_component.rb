# frozen_string_literal: true

module TableGen
  module Columns
    class BooleanColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, dash_if_blank: false, center_content: true, flush: true) do
          render TableGen::Columns::Common::BooleanCheckComponent.new checked: @column.value
        end
      end
    end
  end
end
