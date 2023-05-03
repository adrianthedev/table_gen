# frozen_string_literal: true

module TableGen
  module Columns
    class BaseColumn
      extend ActiveSupport::DescendantsTracker
      extend TableGen::Columns::ColumnExtensions::HasColumnName

      include TableGen::Concerns::IsTableItem
      include TableGen::Concerns::HandlesColumnArgs

      include ActionView::Helpers::UrlHelper

      include TableGen::Concerns::HasHTMLAttributes
      include TableGen::Columns::Concerns::HasDefault

      delegate :view_context, to: ::TableGen::App
      delegate :simple_format, :content_tag, to: :view_context
      delegate :main_app, to: :view_context
      delegate :table_gen, to: :view_context
      delegate :t, to: ::I18n

      attr_reader :id, :block, :sortable, :format_using, :help, :as_label, :as_avatar,
                  :as_description, :index_text_align, :stacked, :computable, :default, :computed,
                  :computed_value, :table, :action, :user, :panel_name, :updatable, :model

      class_attribute :column_name_attribute
      class_attribute :item_type, default: :column

      def initialize(id, **args, &block)
        @id = id
        @name = args[:name]
        @translation_key = args[:translation_key]
        @block = block
        @sortable = args[:sortable] || false
        @format_using = args[:format_using] || nil
        @help = args[:help] || nil
        @default = args[:default] || nil
        @as_label = args[:as_label] || false
        @as_avatar = args[:as_avatar] || false
        @as_description = args[:as_description] || false
        @index_text_align = args[:index_text_align] || :left
        @html = args[:html] || nil
        @value = args[:value] || nil
        @stacked = args[:stacked] || nil
        @table = args[:table]

        @args = args

        @computable = true
        @computed = block.present?
        @computed_value = nil
      end

      def hydrate(model: nil, table: nil, action: nil, panel_name: nil, user: nil)
        @model = model if model.present?
        @table = table if table.present?
        @action = action if action.present?
        @user = user if user.present?
        @panel_name = panel_name if panel_name.present?

        self
      end

      def translation_key
        return @translation_key if @translation_key.present?

        "table_gen.column_translations.#{@id}"
      end

      # Getting the name of the table (user/users, post/posts)
      # We'll first check to see if the user passed a name
      # Secondly we'll try to find a translation key
      # We'll fallback to humanizing the id
      def name
        return @name if custom_name?

        if translation_key && ::TableGen::App.translation_enabled
          t(translation_key, count: 1, default: default_name).capitalize
        else
          default_name
        end
      end

      def plural_name
        default = name.pluralize

        if translation_key && ::TableGen::App.translation_enabled
          t(translation_key, count: 2, default: default).capitalize
        else
          default
        end
      end

      def custom_name?
        @name.present?
      end

      def default_name
        @id.to_s.humanize(keep_id_suffix: true)
      end

      def value(property = nil)
        return @value if @value.present?

        property ||= id

        # Get model value
        final_value = @model.send(property) if model?(@model) && @model.respond_to?(property)

        # On new views and actions modals we need to prefill the columns with the default value
        final_value = computed_default_value if default.present?

        # Run computable callback block if present
        final_value = instance_exec(@model, @table, self, &block) if computable && block.present?

        # Run the value through resolver if present
        final_value = instance_exec(final_value, &@format_using) if @format_using.present?

        final_value
      end

      def fill_column(model, key, value, params)
        return model unless model.methods.include? key.to_sym

        model.send("#{key}=", value)

        model
      end

      # Try to see if the  column has a different database ID than it's name
      def database_id
        foreign_key
      rescue StandardError
        id
      end

      def resolve_attribute(value)
        value
      end

      def to_permitted_param
        id.to_sym
      end

      def view_component_name
        "#{type.camelize}Column"
      end

      # Try and build the component class or fallback to a blank one
      def component_for_view
        component_class = "::TableGen::Columns::#{view_component_name}Component"
        component_class.constantize
      rescue StandardError
        # When returning nil, a race condition happens and throws an error in some environments.
        ::TableGen::BlankColumnComponent
      end

      def type
        self.class.name.demodulize.to_s.underscore.gsub('_column', '')
      end

      def custom?
        !method(:initialize).source_location.first.include?('lib/table_gen/column')
      rescue StandardError
        true
      end

      private

      def model_or_class(model)
        if model.instance_of?(String)
          'class'
        else
          'model'
        end
      end

      def model?(model)
        model_or_class(model) == 'model'
      end
    end
  end
end
