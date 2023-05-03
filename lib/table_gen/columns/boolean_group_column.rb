# frozen_string_literal: true
module TableGen
  module Columns
    class BooleanGroupColumn < BaseColumn
      attr_reader :options

      def initialize(id, **args, &block)
        super(id, **args, &block)

        @options = args[:options].present? ? args[:options] : {}
      end

      def to_permitted_param
        ["#{id}": []]
      end

      def fill_column(model, _key, value, _params)
        new_value = {}

        # Filter out the empty ("") value boolean group generates
        value = value.filter(&:present?)

        # Cast values to booleans
        options.each do |id, _label|
          new_value[id] = value.include? id.to_s
        end

        model[id] = new_value

        model
      end
    end
  end
end
