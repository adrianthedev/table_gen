# frozen_string_literal: true
require_relative 'named_base_generator'

module Generators
  module TableGen
    class ActionGenerator < NamedBaseGenerator
      source_root File.expand_path('templates', __dir__)

      class_option :standalone, type: :boolean

      namespace 'table_gen:action'

      def create_table_file
        type = 'table'

        type = 'standalone' if options[:standalone]

        if type == 'standalone'
          template 'standalone_action.tt', "app/table_gen/actions/#{singular_name}.rb"
        else
          template 'action.tt', "app/table_gen/actions/#{singular_name}.rb"
        end
      end
    end
  end
end
