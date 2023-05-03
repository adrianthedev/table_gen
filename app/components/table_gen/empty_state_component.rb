# frozen_string_literal: true

module TableGen
  class EmptyStateComponent < ViewComponent::Base
    attr_reader :message, :add_background, :by_association

    def initialize(message: nil, add_background: false, by_association: false)
      super
      @message = message
      @add_background = add_background
      @by_association = by_association
    end

    def text
      message || locale_message
    end

    private

    def locale_message
      helpers.t by_association ? 'table_gen.no_related_item_found' : 'table_gen.no_item_found'
    end
  end
end
