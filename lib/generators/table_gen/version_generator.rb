# frozen_string_literal: true
require 'rails/generators'

module Generators
  module TableGen
    class VersionGenerator < ::Rails::Generators::Base
      namespace 'table_gen:version'

      def handle
        if defined? ::TableGen::Engine
          output "TableGen #{::TableGen::VERSION}"
        else
          output 'TableGen not installed.'
        end
      end

      private

      def output(message)
        puts message unless options['quiet']
      end
    end
  end
end
