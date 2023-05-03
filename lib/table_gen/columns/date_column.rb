# frozen_string_literal: true
module TableGen
  module Columns
    class DateColumn < TextColumn
      attr_reader :first_day_of_week, :picker_format, :disable_mobile, :format, :picker_options

      def initialize(id, **args, &block)
        super(id, **args, &block)

        add_string_prop args, :first_day_of_week, 1
        add_string_prop args, :picker_format, 'Y-m-d'
        add_string_prop args, :format, 'yyyy-LL-dd'
        add_boolean_prop args, :disable_mobile
        add_object_prop args, :picker_options
      end

      def formatted_value
        return if value.blank?

        try_iso8601
      end

      def edit_formatted_value
        formatted_value
      end

      private

      def try_iso8601
        if value.respond_to?(:iso8601)
          value.iso8601
        elsif value.is_a?(String)
          parsed = DateTime.parse(value.dup)
          parsed if parsed.present?
        else
          value
        end
      end
    end
  end
end
