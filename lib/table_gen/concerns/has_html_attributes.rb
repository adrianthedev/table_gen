# frozen_string_literal: true

module TableGen
  module Concerns
    module HasHTMLAttributes
      extend ActiveSupport::Concern

      attr_reader :html

      # Used to get attributes for elements and views
      def get_html(name = nil, element:)
        default_attribute_value name if element.nil?

        parsed = parse_html

        if parsed.is_a? Hash
          get_html_from_hash name, element: element, hash: parsed
        elsif parsed.is_a? TableGen::HTML::Builder
          get_html_from_block name, element: element, html_builder: parsed
        elsif parsed.nil?
          # Handle empty parsed by returning an empty state
          default_attribute_value name
        end
      end

      private

      # Returns Hash, HTML::Builder, or nil.
      def parse_html
        return if @html.nil?

        if @html.is_a? Hash
          @html
        elsif @html.respond_to? :call
          TableGen::HTML::Builder.parse_block(record: model, table: table, &@html)
        end
      end

      def default_attribute_value(name)
        name == :data ? {} : ''
      end

      def get_html_from_block(name = nil, element:, html_builder:)
        values = []

        # get view ancestor
        values << html_builder.dig_stack(element, name)
        # get element ancestor
        values << html_builder.dig_stack(element, name)
        # get direct ancestor
        values << html_builder.dig_stack(name)

        values_type = if name == :data
                        :hash
                      else
                        :string
                      end

        merge_values_as(as: values_type, values: values)
      end

      def get_html_from_hash(name = nil, element:, hash:)
        # @todo: what if this is not a Hash but a string?
        hash.dig(element, name) || {}
      end

      # Merge the values from all possible locations.
      # If the result is "blank", return nil so the attributes are not outputted to the DOM.
      #
      # Ex: if the style attribute is empty return `nil` instead of an empty space `" "`
      def merge_values_as(as: :array, values: [])
        result = case as
                 when :array
                   values.flatten
                 when :string
                   values.select do |value|
                     value.is_a? String
                   end.join ' '
                 when :hash
                   values.reduce({}, :merge)
                 end

        result if result.present?
      end
    end
  end
end
