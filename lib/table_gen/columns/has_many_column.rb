module TableGen
  module Columns
    class HasManyColumn < HasBaseColumn
      def initialize(id, **args, &block)
        args[:updatable] = false

        super(id, **args, &block)
      end
    end
  end
end
