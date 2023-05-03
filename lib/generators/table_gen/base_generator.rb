# frozen_string_literal: true

require 'rails/generators'

module Generators
  module TableGen
    class BaseGenerator < ::Rails::Generators::Base
      hide!

      def initialize(*args)
        super(*args)

        # Don't output the version if requested so
        return if args.include?(['--skip-table_gen-version'])

        invoke 'table_gen:version', *args
      end
    end
  end
end
