# frozen_string_literal: true

module TableGen
  module Dsl
    class ColumnParser
      attr_reader :as, :args, :id, :block, :instance, :order_index

      def initialize(id:, order_index: 0, **args, &block)
        @id = id
        @as = args.fetch(:as, nil)
        @order_index = order_index
        @args = args
        @block = block
        @instance = nil
      end

      def valid?
        instance.present?
      end

      def invalid?
        !valid?
      end

      def parse
        # The column is passed as a symbol eg: :text, :color_picker, :trix
        @instance = if as.is_a? Symbol
                      parse_from_symbol
                    elsif as.is_a? Class
                      parse_from_class
                    end

        self
      end

      private

      def parse_from_symbol
        column_class = column_class_from_symbol(as)

        if column_class.present?
          # The column has been registered before.
          instantiate_column(id, klass: column_class, **args, &block)
        else
          # The symbol can be transformed to a class and found.
          class_name = as.to_s.camelize
          column_class = "#{class_name}Column"

          # Discover & load custom column classes
          if Object.const_defined? column_class
            instantiate_column(id, klass: column_class.safe_constantize, **args, &block)
          end
        end
      end

      def parse_from_class
        # The column has been passed as a class.
        return unless Object.const_defined? as.to_s

        instantiate_column(id, klass: as, **args, &block)
      end

      def instantiate_column(id, klass:, **args, &block)
        if block
          klass.new(id, **args || {}, &block)
        else
          klass.new(id, **args || {})
        end
      end

      def column_class_from_symbol(symbol)
        matched_column = TableGen::App.columns.find do |column|
          column[:name].to_s == symbol.to_s
        end

        matched_column[:class] if matched_column.present? && matched_column[:class].present?
      end
    end
  end
end
