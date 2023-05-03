# frozen_string_literal: true

module TableGen
  module Columns
    module Common
      class BooleanCheckComponent < ViewComponent::Base
        include TableGen::ApplicationHelper

        def initialize(checked: false)
          super
          @checked = checked
        end

        def call
          classes = 'h-6 float-left mr-1'

          if @checked
            classes += ' text-green-600'
            icon = 'heroicons/outline/check-circle'
          else
            classes += ' text-red-500'
            icon = 'heroicons/outline/x-circle'
          end

          svg "#{icon}.svg", class: classes
        end
      end
    end
  end
end
