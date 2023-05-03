module TableGen
  module Columns
    class IdColumn < BaseColumn
      attr_reader :link_to_table

      def initialize(id, **args, &block)
        args[:sortable] = true

        super(id, **args, &block)

        @link_to_table = args[:link_to_table].present? ? args[:link_to_table] : false
      end
    end
  end
end
