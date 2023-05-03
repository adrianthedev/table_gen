# frozen_string_literal: true

module TableGen
  # main configs for gem
  class Configuration
    include TableConfiguration

    attr_writer :branding

    attr_accessor :timezone, :per_page, :per_page_steps, :via_per_page, :locale, :currency,
                  :authorization_methods, :authenticate, :current_user, :id_links_to_table, :context,
                  :cache_tables_on_index_view, :cache_table_filters, :raise_error_on_missing_policy,
                  :home_path, :search_debounce, :view_component_path, :sign_out_path_name, :column_wrapper_layout,
                  :current_user_table_name, :model_table_mapping, :tabs_style, :table_default_view,
                  :authorization_client

    def initialize
      @timezone = 'UTC'
      @per_page = 24
      @per_page_steps = [12, 24, 48, 72]
      @via_per_page = 8
      @locale = nil
      @currency = 'USD'
      @current_user = proc {}
      @authenticate = proc {}
      @authorization_methods = {
        index: 'index?',
        show: 'show?',
        edit: 'edit?',
        new: 'new?',
        update: 'update?',
        create: 'create?',
        destroy: 'destroy?'
      }
      @id_links_to_table = false
      @cache_tables_on_index_view = TableGen::PACKED
      @cache_table_filters = false
      @context = proc {}

      @home_path = nil
      @search_debounce = 300
      @view_component_path = 'app/components'
      @current_user_table_name = 'user'
      @raise_error_on_missing_policy = false
      @model_table_mapping = {}
      @tabs_style = :tabs
      @table_default_view = :index
      @authorization_client = :pundit
      @column_wrapper_layout = :inline
    end

    def current_user_method(&block)
      @current_user = block if block.present?
    end

    def current_user_method=(method)
      @current_user = method if method.present?
    end

    def authenticate_with(&block)
      @authenticate = block if block.present?
    end

    def set_context(&block)
      @context = block if block.present?
    end

    def branding
      TableGen::Configuration::Branding.new(**@branding || {})
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
