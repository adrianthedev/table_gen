module TableGen
  module Columns
    class TagsColumn < BaseColumn
      attr_reader :acts_as_taggable_on
      attr_reader :close_on_select
      attr_reader :delimiters
      attr_reader :enforce_suggestions
      attr_reader :mode

      def initialize(id, **args, &block)
        super(id, **args, &block)

        add_boolean_prop args, :close_on_select
        add_boolean_prop args, :enforce_suggestions
        add_string_prop args, :acts_as_taggable_on
        add_array_prop args, :disallowed
        add_array_prop args, :delimiters, [","]
        add_array_prop args, :suggestions
        add_string_prop args, :mode, nil
        add_string_prop args, :fetch_values_from
        add_string_prop args, :fetch_labels
      end

      def column_value
        return fetched_labels if @fetch_labels.present?

        return json_value if acts_as_taggable_on.present?

        value || []
      end

      def json_value
        value.map do |item|
          {
            value: item.name
          }
        end.as_json
      end

      def fill_column(model, key, value, params)
        if acts_as_taggable_on.present?
          model.send(act_as_taggable_attribute(key), value)
        else
          val = if value.is_a?(String)
            value.split(",")
          elsif value.is_a?(Array)
            value
          else
            value
          end
          model.send("#{key}=", val)
        end

        model
      end

      def suggestions
        return @suggestions if @suggestions.is_a? Array

        if @suggestions.respond_to? :call
          return TableGen::Hosts::RecordHost.new(block: @suggestions, record: model).handle
        end

        []
      end

      def disallowed
        return @disallowed if @disallowed.is_a? Array

        if @disallowed.respond_to? :call
          return TableGen::Hosts::RecordHost.new(block: @disallowed, record: model).handle
        end

        []
      end

      def fetch_values_from
        if @fetch_values_from.respond_to?(:call)
          TableGen::Hosts::TableRecordHost.new(block: @fetch_values_from, table: table, record: model).handle
        else
          @fetch_values_from
        end
      end

      private

      def fetched_labels
        if @fetch_labels.respond_to?(:call)
          TableGen::Hosts::TableRecordHost.new(block: @fetch_labels, table: table, record: model).handle
        else
          @fetch_labels
        end
      end

      def act_as_taggable_attribute(key)
        "#{key.singularize}_list="
      end
    end
  end
end
