# frozen_string_literal: true

module TableGen
  class App
    class_attribute :tables, default: []
    class_attribute :cache_store, default: nil
    class_attribute :columns, default: []
    class_attribute :request, default: nil
    class_attribute :context, default: nil
    class_attribute :current_user, default: nil
    class_attribute :root_path, default: nil
    class_attribute :view_context, default: nil
    class_attribute :params, default: {}
    class_attribute :translation_enabled, default: false
    class_attribute :error_messages

    class << self
      def eager_load(entity)
        paths = TableGen::ENTITIES.fetch entity

        return unless paths.present?

        pathname = Rails.root.join(*paths)
        return unless pathname.directory?

        Rails.autoloaders.main.eager_load_dir(pathname.to_s)
      end

      def boot
        init_columns

        if Rails.cache.instance_of?(ActiveSupport::Cache::NullStore)
          self.cache_store ||= ActiveSupport::Cache::MemoryStore.new
        else
          self.cache_store = Rails.cache
        end
      end

      # Generate a dynamic root path using the URIService
      def root_path(paths: [], query: {}, **_args)
        TableGen::Services::URIService.parse(view_context.avo.root_url.to_s)
                                 .append_paths(paths)
                                 .append_query(query)
                                 .to_s
      end

      def init(request:, context:, current_user:, view_context:, params:)
        self.error_messages = []
        self.context = context
        self.current_user = current_user
        self.params = params
        self.request = request
        self.view_context = view_context

        self.translation_enabled = true

        init_active_storage_host(request)
      end

      def init_columns
        TableGen::Columns::BaseColumn.descendants.each do |class_name|
          next if class_name.to_s == 'BaseColumn'

          load_column class_name.get_column_name, class_name if class_name.to_s.end_with? 'Column'
        end
      end

      def load_column(method_name, klass)
        columns.push(
          name: method_name,
          class: klass
        )
      end

      private

      def init_active_storage_host(request)
        if defined?(ActiveStorage::Current)
          if Rails::VERSION::MAJOR === 6
            ActiveStorage::Current.host = request.base_url
          elsif Rails::VERSION::MAJOR === 7
            ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host,
                                                   port: request.port }
          end
        end
      rescue StandardError => exception
        Rails.logger.debug "[TableGen] Failed to set ActiveStorage::Current.url_options, #{exception.inspect}"
      end
    end
  end
end
