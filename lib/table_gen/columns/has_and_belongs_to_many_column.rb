# frozen_string_literal: true
module TableGen
  module Columns
    class HasAndBelongsToManyColumn < HasBaseColumn
      def initialize(id, **args, &block)
        args[:updatable] = false

        super(id, **args, &block)
      end

      def view_component_name
        'HasManyColumn'
      end
    end
  end
end
