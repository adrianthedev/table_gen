# frozen_string_literal: true

module TableGen
  # storage for columns
  class ItemsHolder
    attr_reader :tools
    attr_accessor :items, :invalid_columns

    def initialize
      @items = []
      @items_index = 0
      @invalid_columns = []
    end

    # Adds a column to the bag
    def column(column_name, **args, &block)
      column_parser = TableGen::Dsl::ColumnParser.new(id: column_name, order_index: @items_index, **args, &block).parse

      if column_parser.invalid?
        as = args.fetch(:as, nil)

        # End execution here and add the column to the invalid_columns payload so we know to warn the developer about that
        # @todo: Make sure this warning is still active
        return add_invalid_column({
                                   name: column_name,
                                   as: as,
                                   message: "There's an invalid column configuration for this table. <br/> <code class='px-1 py-px rounded bg-red-600'>column :#{column_name}, as: #{as}</code>"
                                 })
      end

      add_item column_parser.instance
    end

    def tool(klass, **args)
      instance = klass.new(**args)
      add_item instance
    end

    def add_item(instance)
      @items << instance

      increment_order_index
    end

    private

    def add_invalid_column(payload)
      @invalid_columns << payload
    end

    def increment_order_index
      @items_index += 1
    end
  end
end
