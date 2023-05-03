# frozen_string_literal: true

module TableGen
  module Shared
    class FlashAlertsComponent < ViewComponent::Base
      include TableGen::ApplicationHelper

      def initialize(flashes: [])
        super
        @flashes = flashes
      end
    end
  end
end
