# frozen_string_literal: true
require_relative 'base_generator'

module Generators
  module TableGen
    class LocalesGenerator < BaseGenerator
      source_root File.expand_path('templates', __dir__)

      namespace 'table_gen:locales'
      desc 'Add TableGen locale files to your project.'

      def create_files
        directory File.join(__dir__, 'templates', 'locales'), 'config/locales'
      end
    end
  end
end
