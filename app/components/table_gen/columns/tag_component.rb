# frozen_string_literal: true

module TableGen
  module Columns
    class TagComponent < ViewComponent::Base
      attr_reader :label, :title

      def initialize(label: nil, title: nil)
        super
        @label = label
        @title = title
      end

      def call
        content_tag(:div, label, item_attrs)
      end

      private

      def item_attrs
        attrs = {
          class: 'flex px-2 py-1 rounded bg-gray-100 text-sm text-gray-800 font-normal flex-shrink-0',
          data: {
            target: 'tag-component'
          }
        }

        if title.present?
          attrs[:title] = title
          attrs[:data][:tippy] = 'tooltip'
        end

        attrs
      end
    end
  end
end
