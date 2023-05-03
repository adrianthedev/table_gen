# frozen_string_literal: true

module TableGen
  module Table
    module Partials
      # head component for table_gen
      class TableHeadComponent < ViewComponent::Base
        include TableGen::TablesHelper

        def initialize(columns:, table:)
          super
          @columns = columns
          @table = table
        end

        private

        def cell_classes
          'text-left uppercase px-3 py-3 whitespace-nowrap'
        end

        def cell_data_attrs(column)
          {
            control: 'table-column-th',
            table_header_column_id: column.id,
            table_header_column_type: column.type
          }
        end

        def sort_link(column)
          sort_by, sort_direction = column_sort_params(column)
          params.permit!.merge(sort_by: sort_by, sort_direction: sort_direction)
        end

        def column_classes(column)
          classes = 'flex items-center text-gray-500 tracking-tight leading-tight text-xs font-semibold'
          classes += column_alignment_class(column)
          classes += 'cursor-pointer' if column.sortable
          classes
        end

        def column_alignment_class(column)
          case column.index_text_align.to_sym
          when :right
            ' text-right'
          when :center
            ' text-center'
          else
            ''
          end
        end

        def column_sort_params(column)
          sort_by = sort_by_param(column)
          sort_direction = sort_direction_param(sort_by)
          [sort_by, sort_direction]
        end

        def sort_by_param(column)
          return column.id unless sort_by_current_param?(column)

          nil
        end

        def sort_by_current_param?(column)
          params[:sort_by] == column.id.to_s
        end

        def sort_direction_param(sort_by)
          return 'desc' if sort_by.present? && params[:sort_direction] == 'asc'
          return 'asc' if sort_by.nil?

          nil
        end
      end
    end
  end
end
