# frozen_string_literal: true

require_relative 'base_generator'

module Generators
  module TableGen
    class InstallGenerator < BaseGenerator
      source_root File.expand_path('templates', __dir__)

      namespace 'table_gen:install'
      desc 'Creates an TableGen initializer adds the route to the routes file.'

      class_option :path, type: :string, default: 'table_gen'

      def create_initializer_file
        template 'initializer/table_gen.tt', 'config/initializers/table_gen.rb'
        directory File.join(__dir__, 'templates', 'locales'), 'config/locales'
        directory File.join(__dir__, '../', '../', '../', 'app', 'assets', 'builds'), 'app/assets/builds'
      end
    end
  end
end
