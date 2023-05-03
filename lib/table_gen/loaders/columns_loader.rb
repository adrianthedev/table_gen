module TableGen
  module Loaders
    class ColumnsLoader < Loader
      def add_column(column)
        @bag.push column
      end

      def method_missing(method, *args, &block)
        matched_column = TableGen::App.columns.find do |column|
          column[:name].to_s == method.to_s
        end

        if matched_column.present? && matched_column[:class].present?
          klass = matched_column[:class]

          column = if block.present?
            klass.new(args[0], **args[1] || {}, &block)
          else
            klass.new(args[0], **args[1] || {})
          end

          add_column column
        end
      end
    end
  end
end
