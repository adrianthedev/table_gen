# frozen_string_literal: true

module TableGen
  module Index
    module Ordering
      class ButtonComponent < TableGen::Table::Ordering::BaseComponent
        attr_accessor :table, :direction, :svg

        def initialize(table:, direction:, svg: nil)
          super
          @table = table
          @direction = direction
          @svg = svg
        end

        def render?
          order_actions[direction].present?
        end
      end
    end
  end
end
