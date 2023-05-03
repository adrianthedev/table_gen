# frozen_string_literal: true

module TableGen
  module Table
    class ColumnWrapperComponent < ViewComponent::Base
      def initialize(column: nil, table: nil, dash_if_blank: true, center_content: false, flush: false, **args)
        super
        @column = column
        @table = table
        @dash_if_blank = dash_if_blank
        @center_content = center_content
        @classes = args[:class].present? ? args[:class] : ''
        @args = args
        @flush = flush
      end

      def classes
        result = @classes

        result += ' py-3' unless @flush

        result += " #{text_align_classes}"
        result += " #{@column.get_html(:classes, element: :wrapper)}"

        result
      end

      def style
        @column.get_html(:style, element: :wrapper)
      end

      def stimulus_attributes
        attributes = {}

        @table.get_stimulus_controllers.split(' ').each do |controller|
          attributes["#{controller}-target"] =
            "#{@column.id.to_s.underscore}_#{@column.type.to_s.underscore}_wrapper".camelize(:lower)
        end

        wrapper_data_attributes = @column.get_html :data, element: :wrapper
        attributes.merge! wrapper_data_attributes if wrapper_data_attributes.present?

        attributes
      end

      private

      def text_align_classes
        case @column.index_text_align.to_sym
        when :right
          'text-right'
        when :center
          'text-center'
        else
          ''
        end
      end
    end
  end
end
