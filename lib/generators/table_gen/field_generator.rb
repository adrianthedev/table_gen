# frozen_string_literal: true
require_relative 'named_base_generator'

module Generators
  module TableGen
    class FieldGenerator < NamedBaseGenerator
      source_root File.expand_path('templates', __dir__)

      namespace 'table_gen:field'
      desc 'Add a custom TableGen field to your project.'

      def handle
        directory 'field/components', "#{::TableGen.configuration.view_component_path}/table_gen/columns/#{singular_name}_field"
        template 'field/%singular_name%_field.rb.tt', "app/table_gen/columns/#{singular_name}_field.rb"
      end
    end
  end
end
