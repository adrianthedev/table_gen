# frozen_string_literal: true
module TableGen
  module Columns
    class TextColumn < BaseColumn
      attr_reader :link_to_table, :as_html, :protocol

      def initialize(id, **args, &block)
        super(id, **args, &block)

        add_boolean_prop args, :link_to_table
        add_boolean_prop args, :as_html
        add_string_prop args, :protocol
      end
    end
  end
end
