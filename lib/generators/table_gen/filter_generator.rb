# frozen_string_literal: true
require_relative 'named_base_generator'

module Generators
  module TableGen
    class FilterGenerator < NamedBaseGenerator
      source_root File.expand_path('templates', __dir__)

      class_option :multiple_select, type: :boolean
      class_option :select, type: :boolean
      class_option :text, type: :boolean

      namespace 'table_gen:filter'

      def create_table_file
        type = 'boolean'

        type = 'multiple_select' if options[:multiple_select]
        type = 'select' if options[:select]
        type = 'text' if options[:text]

        template "filters/#{type}_filter.tt", "app/table_gen/filters/#{singular_name}.rb"
      end
    end
  end
end
