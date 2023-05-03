# frozen_string_literal: true

module TableGen
  module Partials
    class ActionsComponent < ViewComponent::Base
      include TableGen::ApplicationHelper
      attr_reader :label

      def initialize(actions: [], table: nil, exclude: [], style: :outline, color: :primary, label: nil)
        super
        @actions = actions || []
        @table = table
        @exclude = exclude
        @color = color
        @style = style
        @label = label || t('avo.actions')
      end

      def render?
        actions.present?
      end

      def actions
        @actions.reject { |action| action.class.in?(@exclude) }
      end

      # When running an action for one record we should do it on a special path.
      # We do that so we get the `model` param inside the action so we can prefill columns.
      def action_path(id)
        return many_records_path(id) unless @table.model_id?

        if on_record_page?
          single_record_path id
        else
          many_records_path id
        end
      end

      # How should the action be displayed by default
      def is_disabled?(action)
        return false if action.standalone

        on_index_page?
      end

      private

      def single_record_path(id)
        TableGen::Services::URIService.parse(@table.record_path)
                                      .append_paths('actions', id)
                                      .to_s
      end

      def many_records_path(id)
        TableGen::Services::URIService.parse(@table.records_path)
                                      .append_paths('actions', id)
                                      .to_s
      end
    end
  end
end
