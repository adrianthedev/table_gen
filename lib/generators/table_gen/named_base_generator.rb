# frozen_string_literal: true
require 'rails/generators'

module Generators
  module TableGen
    class NamedBaseGenerator < ::Rails::Generators::NamedBase
      hide!

      def initialize(name, *options)
        super(name, *options)
        invoke 'table_gen:version', name, *options
      end
    end
  end
end
