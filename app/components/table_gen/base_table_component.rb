# frozen_string_literal: true

module TableGen
  # base functions for table_gen components
  class BaseTableComponent < ViewComponent::Base
    include Turbo::FramesHelper
    include TableGen::ApplicationHelper

    attr_reader :table_tools, :table

    def singular_table_name
      @table.singular_name || @table.model_class.model_name.name.downcase
    end

    def can_see_the_actions_button?
      return false if @actions.blank?

      @table.authorization.authorize_action(:act_on, raise_exception: false)
    end
  end
end
