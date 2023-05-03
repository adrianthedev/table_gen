# frozen_string_literal: true

module TableGen
  module Columns
    class ExternalImageColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, flush: true) do
          if @column.value.present?
            link_to_if @column.link_to_table.present?,
                       image_tag(
                         @column.value,
                         height: @column.height,
                         style: "border-radius: #{@column.radius}px; max-height: #{@column.height}#{@column.height.to_s&.ends_with?('px') ? '' : 'px'};"
                       ), table_view_path
          end
        end
      end
    end
  end
end
