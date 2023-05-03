# frozen_string_literal: true

require 'rails/generators/active_record/model/model_generator'

module Rails
  module Generators
    class TableGenerator < ::Rails::Generators::Base
      def invoke_avo_command
        invoke 'table_gen:table', @args, { from_model_generator: true }
      end
    end
  end
end
