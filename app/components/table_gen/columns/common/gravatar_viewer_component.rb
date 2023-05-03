# frozen_string_literal: true

module TableGen
  module Columns
    module Common
      class GravatarViewerComponent < ViewComponent::Base
        def initialize(md5: nil, link: nil, default: nil, size: nil, rounded: false, link_to_table: false, title: nil)
          super
          @md5 = md5
          @link = link
          @default = default
          @size = size
          @rounded = rounded
          @link_to_table = link_to_table
          @title = title
        end

        def call
          options = { default: '', size: 340 }
          options[:default] = @default if @default.present?
          options[:size] = @size if @size.present?

          query = options.map { |key, value| "#{key}=#{value}" }.join('&')
          url = URI::HTTPS.build(host: 'www.gravatar.com', path: "/avatar/#{@md5}", query: query)

          classes = @rounded ? 'rounded-full' : ''

          link_to_if @link_to_table.present?,
                     image_tag(
                       url.to_s,
                       class: classes,
                       width: options[:size],
                       height: options[:size]
                     ), @link, title: @title
        end
      end
    end
  end
end
