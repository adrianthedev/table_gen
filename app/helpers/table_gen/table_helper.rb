# frozen_string_literal: true

module TableGen
  module TableHelper
    include ::Pagy::Backend

    def table_for(table)
      @table = table.new.hydrate(params: params)

      set_index_params

      # If we don't get a query object predefined from a child controller like associations, just spin one up
      @query = table.query_scope unless defined? @query

      @query = @query.unscoped if @table.unscoped_queries_on_index

      # Eager load the associations
      @query = @query.includes(*@table.includes) if @table.includes.present?

      # Eager load the active storage attachments
      @query = eager_load_files(@table, @query)

      # Sort the items
      if @index_params[:sort_by].present?
        @query = @query.unscope(:order) unless @index_params[:sort_by].eql? :created_at

        # Check if the sortable column option is actually a proc and we need to do a custom sort
        column_id = @index_params[:sort_by].to_sym
        column = @table.column_definitions.find { |f| f.id == column_id }

        @query = if column&.sortable.is_a?(Proc)
                   column.sortable.call(@query, @index_params[:sort_direction])
                 else
                   @query.order("#{@table.model_class.table_name}.#{@index_params[:sort_by]} #{@index_params[:sort_direction]}")
                 end
      end

      @pagy, @models = pagy(@query, items: @index_params[:per_page],
                                    link_extra: "data-turbo-frame=\"#{params[:turbo_frame]}\"",
                                    size: [1, 2, 2, 1])

      # Create tables for each model
      @tables = @models.map do |model|
        @table.hydrate(model: model, params: params).dup
      end

      @filters = []

      render TableGen::TableComponent.new(
        table: @table,
        tables: @tables,
        models: @models,
        pagy: @pagy,
        index_params: @index_params,
        filters: @filters,
        actions: @actions,
        turbo_frame: params[:turbo_frame],
        applied_filters: @applied_filters,
        query: @query
      )
    end

    private

    def params
      # Rack::Utils.parse_nested_query(env['QUERY_STRING'])
      TableGen::App.params
    end

    def set_index_params
      @index_params = {}

      # Pagination
      @index_params[:page] = params[:page] || 1
      @index_params[:per_page] = TableGen.configuration.per_page

      @index_params[:per_page] = cookies[:per_page] if cookies[:per_page].present?

      if params[:per_page].present?
        @index_params[:per_page] = params[:per_page]
        cookies[:per_page] = params[:per_page]
      end

      # Sorting
      if params[:sort_by].present?
        @index_params[:sort_by] = params[:sort_by]
      elsif @table.model_class.present? && @table.model_class.column_names.include?('created_at')
        @index_params[:sort_by] = :created_at
      end

      @index_params[:sort_direction] = params[:sort_direction] || :desc
    end

    def eager_load_files(table, query)
      unless table.attached_file_columns.empty?
        table.attached_file_columns.map do |column|
          attachment = case column.class.to_s
                       when 'TableGen::Columns::FileColumn'
                         'attachment'
                       when 'TableGen::Columns::FilesColumn'
                         'attachments'
                       else
                         'attachment'
                       end

          return query.includes "#{column.id}_#{attachment}": :blob
        end
      end

      query
    end
  end
end
