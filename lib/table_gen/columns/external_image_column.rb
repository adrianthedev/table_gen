# frozen_string_literal: true
module TableGen
  module Columns
    class ExternalImageColumn < BaseColumn
      attr_reader :width, :height, :radius, :link_to_table

      def initialize(id, **args, &block)
        super(id, **args, &block)

        @link_to_table = args[:link_to_table].present? ? args[:link_to_table] : false

        @width = args[:width].present? ? args[:width] : 40
        @height = args[:height].present? ? args[:height] : 40
        @radius = args[:radius].present? ? args[:radius] : 0
      end

      def to_image
        value
      end
    end
  end
end
