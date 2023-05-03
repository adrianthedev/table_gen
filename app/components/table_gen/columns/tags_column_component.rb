# frozen_string_literal: true

module TableGen
  module Columns
    class TagsColumnComponent < TableGen::Columns::IndexComponent
      include TableGen::Columns::Concerns::ItemLabels

      def call
        index_column_wrapper(**column_wrapper_args, flush: true) do
          content_tag(:div, class: 'flex gap-1 items-center flex-nowrap') do
            render_tags(@column.column_value.take(3))

            if @column.column_value.count > 3
              render_more_tag(@column.column_value.count - 3)
            end
          end
        end
      end

      private

      def render_tags(items)
        items.each do |item|
          render TableGen::Columns::TagComponent.new(label: label_from_item(item))
        end
      end

      def render_more_tag(count)
        render TableGen::Columns::TagComponent.new(
          label: '...',
          title: I18n.t('avo.x_items_more', count: count)
        )
      end
    end
  end
end
