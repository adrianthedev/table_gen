# frozen_string_literal: true
require 'digest'
require 'erb'

module TableGen
  module Columns
    class GravatarColumn < BaseColumn
      attr_reader :link_to_table, :rounded, :size, :default

      def initialize(id, **args, &block)
        args[:name] ||= 'Avatar'

        super(id, **args, &block)

        @link_to_table = args[:link_to_table].present? ? args[:link_to_table] : false
        @rounded = args[:rounded].nil? ? true : args[:rounded]
        @size = args[:size].present? ? args[:size].to_i : 32
        @default = args[:default].present? ? ERB::Util.url_encode(args[:default]).to_s : ''
      end

      def md5
        return if value.blank?

        Digest::MD5.hexdigest(value.strip.downcase)
      end

      def to_image
        options = {
          default: '',
          size: 340
        }

        query = options.map { |key, value| "#{key}=#{value}" }.join('&')

        URI::HTTPS.build(host: 'www.gravatar.com', path: "/avatar/#{md5}", query: query).to_s
      end
    end
  end
end
