# frozen_string_literal: true
module TableGen
  module Columns
    class HasBaseColumn < BaseColumn
      include TableGen::Columns::Concerns::UseTable

      attr_accessor :display, :searchable, :attach_scope,
                    :description, :hide_search_input, :scope

      def initialize(id, **args, &block)
        super(id, **args, &block)

        @scope = args[:scope].present? ? args[:scope] : nil
        @attach_scope = args[:attach_scope].present? ? args[:attach_scope] : nil
        @display = args[:display].present? ? args[:display] : :show
        @searchable = args[:searchable] == true
        @hide_search_input = args[:hide_search_input] || false
        @description = args[:description]
        @use_table = args[:use_table] || nil
      end

      def table
        @table || TableGen::App.get_table_by_model_name(@model.class)
      end

      def turbo_frame
        "#{self.class.name.demodulize.to_s.underscore}_#{display}_#{frame_id}"
      end

      def frame_url
        TableGen::Services::URIService.parse(@table.record_path)
          .append_path(id.to_s)
          .append_query(turbo_frame: turbo_frame.to_s)
          .to_s
      end

      # The value
      def column_value
        value.send(database_value)
      rescue StandardError
        nil
      end

      # What the user sees in the text column
      def column_label
        value.send(target_table.class.title)
      rescue StandardError
        nil
      end

      def target_table
        if @model._reflections[id.to_s].klass.present?
          TableGen::App.get_table_by_model_name @model._reflections[id.to_s].klass.to_s
        elsif @model._reflections[id.to_s].options[:class_name].present?
          TableGen::App.get_table_by_model_name @model._reflections[id.to_s].options[:class_name]
        else
          TableGen::App.get_table_by_name id.to_s
        end
      end

      def placeholder
        @placeholder || I18n.t('avo.choose_an_option')
      end

      def has_own_panel?
        true
      end
      def authorized?
        method = "view_#{id}?".to_sym
        service = table.authorization

        if service.has_method? method
          service.authorize_action(method, raise_exception: false)
        else
          true
        end
      end

      def default_name
        use_table&.name || super
      end

      private

      def frame_id
        use_table.present? ? use_table.route_key.to_sym : @id
      end

      def default_view
        TableGen.configuration.skip_show_view ? :edit : :show
      end
    end
  end
end
