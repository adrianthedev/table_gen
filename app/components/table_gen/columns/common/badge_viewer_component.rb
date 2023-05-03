# frozen_string_literal: true

module TableGen
  module Columns
    module Common
      # i have no idea what it is
      class BadgeViewerComponent < ViewComponent::Base
        def initialize(value:, options:)
          super
          @value = value
          @options = options
        end

        def call
          background = :info

          @options.invert.each do |values, type|
            if [values].flatten.include?(@value.to_sym)
              background = type.to_sym
              break
            end
          end

          classes = 'whitespace-nowrap rounded-md uppercase px-2 py-1 text-xs font-bold block text-center truncate '

          classes += "#{default_backgrounds[background]} text-white" if default_backgrounds[background].present?

          content_tag(:span, @value, class: classes, style: "max-width: 120px;")
        end

        private

        def default_backgrounds
          {
            info: 'bg-blue-500',
            success: 'bg-green-500',
            danger: 'bg-red-500',
            warning: 'bg-yellow-500'
          }
        end
      end
    end
  end
end
