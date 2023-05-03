# frozen_string_literal: true
module TableGen
  module Concerns
    module HasStimulusControllers
      extend ActiveSupport::Concern

      included do
        class_attribute :stimulus_controllers, default: ''
      end

      def get_stimulus_controllers
        controllers = ['table-index', self.class.stimulus_controllers]
        controllers.join ' '
      end

      def stimulus_data_attributes
        {
          controller: get_stimulus_controllers
        }
      end
    end
  end
end
