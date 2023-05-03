# frozen_string_literal: true
module TableGen
  module Columns
    class FilesColumn < BaseColumn
      attr_accessor :is_audio, :is_image, :direct_upload, :accept
      attr_reader :display_filename

      def initialize(id, **args, &block)
        super(id, **args, &block)

        @is_audio = args[:is_audio].present? ? args[:is_audio] : false
        @is_image = args[:is_image].present? ? args[:is_image] : @is_avatar
        @direct_upload = args[:direct_upload].present? ? args[:direct_upload] : false
        @accept = args[:accept].present? ? args[:accept] : nil
        @display_filename = args[:display_filename].nil? ? true : args[:display_filename]
      end

      def view_component_name
        'FilesColumn'
      end

      def to_permitted_param
        {"#{id}": []}
      end

      def fill_column(model, key, value, params)
        return model unless model.methods.include? key.to_sym

        value.each do |file|
          # Skip empty values
          next unless file.present?

          model.send(key).attach file
        end

        model
      end
    end
  end
end
