# frozen_string_literal: true

module TableGen
  module Partials
    # filter component for table
    class FiltersComponent < ViewComponent::Base
      include TableGen::ApplicationHelper

      def initialize(filters: [], table: nil, applied_filters: [])
        super
        @filters = filters
        @table = table
        @applied_filters = applied_filters
      end

      def render?
        @filters.present?
      end

      def reset_path
        helpers.tables_path(table: @table, filters: nil, reset_filter: true, keep_query_params: true)
      end
    end
  end
end
