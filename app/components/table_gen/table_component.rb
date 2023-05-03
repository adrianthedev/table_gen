# frozen_string_literal: true

module TableGen
  class TableComponent < TableGen::BaseTableComponent
    include TableGen::TablesHelper
    include TableGen::ApplicationHelper

    def initialize(table: nil, tables: nil, models: [],
                   pagy: nil, index_params: {}, filters: [],
                   actions: [], turbo_frame: '', applied_filters: [], query: nil)
      super
      @table = table
      @tables = tables
      @models = models
      @pagy = pagy
      @index_params = index_params
      @filters = filters
      @actions = actions
      @turbo_frame = turbo_frame
      @applied_filters = applied_filters
      @query = query
    end

    def title
      @table.plural_name
    end

    # The Create button is dependent on the new? policy method.
    # The create? should be called only when the user clicks the Save button so the developers gets access to the params from the form.
    def can_see_the_create_button?
      @table.authorization.authorize_action(:new, raise_exception: false)
    end

    def create_path
      root_path
      # helpers.new_table_path(table: @table, **args)
    end

    def description
      @table.table_description
    end

    def show_search_input
      return false unless authorized_to_search?
      return false unless @table.search_query.present?
      return false if column&.hide_search_input

      true
    end

    def authorized_to_search?
      # Hide the search if the authorization prevents it
      return true unless @table.authorization.has_action_method?('search')

      @table.authorization.authorize_action('search', raise_exception: false)
    end

    private

    def name
      column.custom_name? ? column.name : column.plural_name
    end
  end
end
