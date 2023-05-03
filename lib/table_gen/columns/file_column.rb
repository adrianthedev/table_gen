# frozen_string_literal: true
module TableGen
  module Columns
    class FileColumn < BaseColumn
      attr_accessor :link_to_table, :is_avatar, :is_image, :is_audio, :direct_upload, :accept
      attr_reader :display_filename

      def initialize(id, **args, &block)
        super(id, **args, &block)

        @link_to_table = args[:link_to_table].present? ? args[:link_to_table] : false
        @is_avatar = args[:is_avatar].present? ? args[:is_avatar] : false
        @is_image = args[:is_image].present? ? args[:is_image] : @is_avatar
        @is_audio = args[:is_audio].present? ? args[:is_audio] : false
        @direct_upload = args[:direct_upload].present? ? args[:direct_upload] : false
        @accept = args[:accept].present? ? args[:accept] : nil
        @display_filename = args[:display_filename].nil? ? true : args[:display_filename]
      end

      def path
        rails_blob_url value
      end
    end
  end
end
