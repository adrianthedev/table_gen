# frozen_string_literal: true
require 'rails/generators'
require 'rails/generators/rails/model/model_generator'

module Rails
  module Generators
    class ModelGenerator
      hook_for :table_gen_table, type: :boolean, default: true unless ARGV.include?('--skip-table')
    end
  end
end
