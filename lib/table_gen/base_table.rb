# frozen_string_literal: true

module TableGen
  # parent table for all tables
  class BaseTable
    extend ActiveSupport::DescendantsTracker

    include ActionView::Helpers::UrlHelper

    include TableGen::Concerns::HasColumns
    include TableGen::Concerns::HasStimulusControllers
    include TableGen::Concerns::ModelClassConstantized

    delegate :view_context, :current_user, :params, :context, to: ::TableGen::App
    delegate :simple_format, :content_tag, :main_app, :table_gen, to: :view_context
    delegate :t, to: ::I18n

    attr_accessor :reflection, :user, :params

    class_attribute :id, :description, default: :id
    class_attribute :namespace, :includes, default: []
    class_attribute :search_query, default: nil
    class_attribute :authorization_policy, :translation_key, :actions_loader, :filters_loader
    class_attribute :unscoped_queries_on_index, default: false
    class_attribute :resolve_query_scope, :resolve_find_scope
    class_attribute :ordering
    class_attribute :record_selector, default: true
    class_attribute :keep_filters_panel_open, default: false

    # TODO: refactor this into a Host without args
    class_attribute :find_record_method, default: ->(model_class:, id:) { model_class.find(id) }

    class << self
      delegate :t, to: ::I18n
      delegate :context, to: ::TableGen::App

      def action(action_class, arguments: {})
        self.actions_loader ||= TableGen::Loaders::Loader.new

        action = { class: action_class, arguments: arguments }
        self.actions_loader.use action
      end

      def filter(filter_class, arguments: {})
        self.filters_loader ||= TableGen::Loaders::Loader.new

        filter = { class: filter_class, arguments: arguments }
        self.filters_loader.use filter
      end

      # This is the search_query scope
      # This should be removed and passed to the search block
      def scope
        query_scope
      end

      # This resolves the scope when doing "where" queries (not find queries)
      def query_scope
        final_scope = resolve_query_scope.present? ? resolve_query_scope.call(model_class: model_class) : model_class
        authorization.apply_policy final_scope
      end

      # This resolves the scope when finding records (not "where" queries)
      def find_scope
        final_scope = resolve_find_scope.present? ? resolve_find_scope.call(model_class: model_class) : model_class

        authorization.apply_policy final_scope
      end

      def authorization
        TableGen::Services::AuthorizationService.new(
          TableGen::App.current_user,
          model_class,
          policy_class: authorization_policy
        )
      end

      def order_actions
        return {} if ordering.blank?

        ordering[:actions] || {}
      end
    end

    def initialize
      return if self.class.model_class.present?
      return unless model_class.present? && model_class.respond_to?(:base_class)

      self.class.model_class = model_class.base_class
    end

    def record
      @model
    end

    alias model record

    def hydrate(model: nil, user: nil, params: nil)
      @user = user if user.present?
      @params = params if params.present?

      @model = model if model.present?

      self
    end

    def filters
      return [] if self.class.filters_loader.blank?

      self.class.filters_loader.bag
    end

    def get_filter_arguments(filter_class)
      filter = filters.find { |f| f[:class] == filter_class.constantize }

      filter[:arguments]
    end

    def actions
      return [] if self.class.actions_loader.blank?

      self.class.actions_loader.bag
    end

    def get_action_arguments(action_class)
      action = actions.find { |a| a[:class].to_s == action_class.to_s }

      action[:arguments]
    end

    def class_name_without_table
      self.class.name.demodulize.delete_suffix('Table')
    end

    def model_class
      # get the model class off of the static property
      return self.class.model_class if self.class.model_class.present?

      # get the model class off of the model
      return @model.base_class if @model.present?

      # generate a model class
      class_name_without_table.safe_constantize
    end

    def model_id
      @model.send id
    end

    def model_title
      return name if @model.nil?

      the_title = @model.send title
      return the_title if the_title.present?

      model_id
    rescue StandardError
      name
    end

    def table_description
      return instance_exec(&self.class.description) if self.class.description.respond_to? :call

      self.class.description if self.class.description.is_a? String
    end

    def translation_key
      if ::TableGen::App.translation_enabled
        return "table_gen.table_translations.#{class_name_without_table.underscore}"
      end

      self.class.translation_key
    end

    def name
      default = class_name_without_table.to_s.gsub('::', ' ').underscore.humanize

      return @name if @name.present?

      if translation_key && ::TableGen::App.translation_enabled
        t(translation_key, count: 1, default: default).capitalize
      else
        default
      end
    end

    def singular_name
      name
    end

    def plural_name
      default = name.pluralize

      if translation_key && ::TableGen::App.translation_enabled
        t(translation_key, count: 2, default: default).capitalize
      else
        default
      end
    end

    def attached_file_columns
      column_definitions.select do |column|
        [TableGen::Columns::FileColumn, TableGen::Columns::FilesColumn].include? column.class
      end
    end

    def authorization(user: nil)
      current_user = user || TableGen::App.current_user

      TableGen::Services::AuthorizationService.new(
        current_user,
        model || model_class,
        policy_class: authorization_policy
      )
    end

    def route_key
      class_name_without_table.underscore.pluralize
    end

    def singular_route_key
      route_key.singularize
    end

    # This is used as the model class ID
    # We use this instead of the route_key to maintain compatibility with uncountable models
    # With uncountable models route key appends an _index suffix (Fish->fish_index)
    # Example: User->users, MediaItem->media_items, Fish->fish
    def model_key
      model_class.model_name.plural
    end

    def model_name
      model_class.model_name
    end

    def label_column
      column_definitions.find do |column|
        column.as_label.present?
      end
    rescue StandardError
      nil
    end

    def label
      label_column&.value || model_title
    end

    def avatar_column
      column_definitions.find do |column|
        column.as_avatar.present?
      end
    rescue StandardError
      nil
    end

    def avatar
      return avatar_column.to_image if avatar_column.respond_to? :to_image

      return avatar_column.value.variant(resize_to_limit: [480, 480]) if avatar_column.type == 'file'

      avatar_column.value
    rescue StandardError
      nil
    end

    def avatar_type
      avatar_column.as_avatar
    rescue StandardError
      nil
    end

    def description_column
      column_definitions.find do |column|
        column.as_description.present?
      end
    rescue StandardError
      nil
    end

    def description
      description_column&.value
    end

    def model_id?
      model.present? && model.id.present?
    end

    def find_record(id, query: nil)
      query ||= self.class.find_scope

      self.class.find_record_method.call(model_class: query, id: id)
    end
  end
end
