# frozen_string_literal: true

module TableGen
  class PanelComponent < ViewComponent::Base
    include ApplicationHelper

    attr_reader :name, :classes

    renders_one :tools
    renders_one :body
    renders_one :sidebar
    renders_one :bare_content
    renders_one :footer_tools
    renders_one :footer

    def initialize(name: nil, description: nil, body_classes: nil, data: {}, index: nil, classes: nil, **args)
      super
      @name = name
      @description = description
      @classes = classes
      @body_classes = body_classes
      @data = data
      @index = index
    end

    private

    def data_attributes
      @data.merge({ "panel-index": @index })
    end

    def description
      return @description if @description.present?

      ''
    end

    def render_header?
      @name.present? || description.present? || tools.present?
    end
  end
end
