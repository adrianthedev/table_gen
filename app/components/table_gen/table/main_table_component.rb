# frozen_string_literal: true

module TableGen
  module Table
    # table_gen main component
    class MainTableComponent < ViewComponent::Base
      include TableGen::ApplicationHelper

      attr_reader :pagy, :query

      def initialize(tables: nil, table: nil, pagy: nil, query: nil)
        super
        @tables = tables
        @table = table
        @pagy = pagy
        @query = query
      end

      def encrypted_query
        return :select_all_disabled if query.nil? || !query.respond_to?(:all) || !query.all.respond_to?(:to_sql)

        TableGen::Services::EncryptionService.encrypt(
          message: query.all.to_sql,
          purpose: :select_all
        )
      end
    end
  end
end
