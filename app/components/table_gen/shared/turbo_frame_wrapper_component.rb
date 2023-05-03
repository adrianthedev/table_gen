# frozen_string_literal: true

module TableGen
  module Shared
    class TurboFrameWrapperComponent < ViewComponent::Base
      attr_reader :name

      def initialize(name = nil)
        super
        @name = name
      end
    end
  end
end
