# frozen_string_literal: true

module TableGen
  module Partials
    # component for pagy paginator
    class PaginatorComponent < ViewComponent::Base
      include TableGen::ApplicationHelper

      attr_reader :pagy, :turbo_frame, :index_params, :table

      def initialize(table: nil, pagy: nil, turbo_frame: nil, index_params: nil)
        super
        @pagy = pagy
        @turbo_frame = turbo_frame
        @index_params = index_params
        @table = table
      end

      def change_items_per_page_url(option)
        root_path(per_page: option, page: 1)
      end

      private

      def per_page_options
        per_page_options = [
          *TableGen.configuration.per_page_steps,
          TableGen.configuration.per_page.to_i,
          index_params[:per_page].to_i
        ]

        per_page_options.sort.uniq
      end
    end
  end
end
