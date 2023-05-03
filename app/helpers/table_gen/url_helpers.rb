# frozen_string_literal: true

module TableGen
  module UrlHelpers
    def tables_path(table:, keep_query_params: false, **args)
      return if table.nil?

      existing_params = {}

      if keep_query_params
        begin
          existing_params = Addressable::URI.parse(request.fullpath).query_values.symbolize_keys
        rescue StandardError
          # Ignored
        end
      end

      route_key = table.route_key
      # Add the `_index` suffix for the uncountable names so they get the correct path (`fish_index`)
      route_key << '_index' if table.route_key == table.singular_route_key

      table_gen.send :"tables_#{route_key}_path", **existing_params, **args
    end

    def table_path(model:, table_id: nil, **args)
      if model.respond_to? :id
        id = model
      elsif table_id.present?
        id = table_id
      end

      table_gen.send :"tables_#{resource.singular_route_key}_path", id, **args
    end

    def new_resource_path(resource:, **args)
      table_gen.send :"new_resources_#{resource.singular_route_key}_path", **args
    end

    def edit_resource_path(model:, resource:, **args)
      table_gen.send :"edit_resources_#{resource.singular_route_key}_path", model, **args
    end

    def resource_view_path(**args)
      resource_path(**args)
    end
  end
end
