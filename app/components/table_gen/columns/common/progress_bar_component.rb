# frozen_string_literal: true

module TableGen
  module Columns
    module Common
      # progress bar components
      class ProgressBarComponent < ViewComponent::Base
        attr_reader :value, :display_value, :value_suffix, :max

        def initialize(value:, display_value: false, value_suffix: nil, max: 100)
          super
          @value = value
          @display_value = display_value
          @value_suffix = value_suffix
          @max = max
        end
      end
    end
  end
end
