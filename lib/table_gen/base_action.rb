module TableGen
  class BaseAction
    include TableGen::Concerns::HasColumns

    class_attribute :name, default: nil
    class_attribute :message
    class_attribute :confirm_button_label
    class_attribute :cancel_button_label
    class_attribute :no_confirmation, default: false
    class_attribute :model
    class_attribute :user
    class_attribute :table
    class_attribute :standalone, default: false
    class_attribute :may_download_file, default: false

    attr_accessor :response, :model, :table, :user
    attr_reader :arguments

    delegate :context, to: ::TableGen::App
    delegate :current_user, to: ::TableGen::App
    delegate :params, to: ::TableGen::App
    delegate :view_context, to: ::TableGen::App
    delegate :table_gen, to: :view_context
    delegate :main_app, to: :view_context

    class << self
      delegate :context, to: ::TableGen::App

      def form_data_attributes
        # We can't respond with a file download from Turbo se we disable it on the form
        if may_download_file
          {turbo: false, remote: false, action_target: :form}
        else
          {turbo_frame: :_top, action_target: :form}
        end
      end

      # We can't respond with a file download from Turbo se we disable close the modal manually after a while (it's a hack, we know)
      def submit_button_data_attributes
        if may_download_file
          {action: "click->modal#delayedClose"}
        else
          {}
        end
      end
    end

    def action_name
      return name if name.present?

      self.class.to_s.demodulize.underscore.humanize(keep_id_suffix: true)
    end

    def initialize(model: nil, table: nil, user: nil, arguments: {})
      self.class.model = model if model.present?
      self.class.table = table if table.present?
      self.class.user = user if user.present?
      @arguments = arguments

      self.class.message ||= I18n.t("avo.are_you_sure_you_want_to_run_this_option")
      self.class.confirm_button_label ||= I18n.t("avo.run")
      self.class.cancel_button_label ||= I18n.t("avo.cancel")

      @response ||= {}
      @response[:messages] = []
    end

    def get_message
      if self.class.message.respond_to? :call
        TableGen::Hosts::TableRecordHost.new(block: self.class.message, record: self.class.model, table: self.class.table).handle
      else
        self.class.message
      end
    end

    def get_attributes_for_action
      get_columns.map do |column|
        [column.id, column.value || column.default]
      end.to_h
    end

    def handle_action(**args)
      models, columns, current_user, table = args.values_at(:models, :columns, :current_user, :table)
      # Fetching the column definitions and not the actual columns (get_columns) because they will break if the user uses a `visible` block and adds a condition using the `params` variable. The params are different in the show method and the handle method.
      action_columns = column_definitions.map { |column| [column.id, column] }.to_h

      # For some columns, like belongs_to, the id and database_id differ (user vs user_id).
      # That's why we need to fetch the database_id for when we process the action.
      action_columns_by_database_id = action_columns.map do |id, value|
        [value.database_id.to_sym, value]
      end.to_h

      if columns.present?
        processed_columns = columns.to_unsafe_h.map do |name, value|
          column = action_columns_by_database_id[name.to_sym]

          next if column.blank?

          [name, column.resolve_attribute(value)]
        end

        processed_columns = processed_columns.reject(&:blank?).to_h
      else
        processed_columns = {}
      end

      args = {
        columns: processed_columns.with_indifferent_access,
        current_user: current_user,
        table: table
      }

      args[:models] = models unless standalone

      handle(**args)

      self
    end

    def param_id
      self.class.to_s.demodulize.underscore.tr "/", "_"
    end

    def succeed(text)
      add_message text, :success

      self
    end

    def fail(text)
      Rails.logger.warn "DEPRECATION WARNING: Action fail method is deprecated in favor of error method and will be removed from TableGen version 3.0.0"

      error text
    end

    def error(text)
      add_message text, :error

      self
    end

    def inform(text)
      add_message text, :info

      self
    end

    def warn(text)
      add_message text, :warning

      self
    end

    def keep_modal_open
      response[:keep_modal_open] = true

      self
    end

    # Add a placeholder silent message from when a user wants to do a redirect action or something similar
    def silent
      add_message nil, :silent

      self
    end

    def redirect_to(path = nil, &block)
      response[:type] = :redirect
      response[:path] = if block.present?
        block
      else
        path
      end

      self
    end

    def reload
      response[:type] = :reload

      self
    end

    def download(path, filename)
      response[:type] = :download
      response[:path] = path
      response[:filename] = filename

      self
    end

    # We're overriding this method to hydrate with the proper table attribute.
    def hydrate_columns(model: nil)
      columns.map do |column|
        column.hydrate(model: @model, table: table)
      end

      self
    end

    private

    def add_message(body, type = :info)
      response[:messages] << {
        type: type,
        body: body
      }
    end
  end
end
