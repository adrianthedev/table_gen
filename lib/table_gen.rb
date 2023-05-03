# frozen_string_literal: true

require 'zeitwerk'
require_relative 'table_gen/version'
require_relative 'table_gen/engine' if defined?(Rails)

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect(
  'html' => 'HTML',
  'uri_service' => 'URIService',
  'has_html_attributes' => 'HasHTMLAttributes'
)
loader.ignore("#{__dir__}/generators")
loader.setup

module TableGen
  ROOT_PATH = Pathname.new(File.join(__dir__, '..'))
  IN_DEVELOPMENT = ENV['AVO_IN_DEVELOPMENT'] == '1'
  PACKED = !IN_DEVELOPMENT
  COOKIES_KEY = 'table_gen'
  ENTITIES = {
    fields: %w[app table_gen columns],
    filters: %w[app table_gen filters],
    actions: %w[app table_gen actions],
    table_tools: %w[app table_gen table_tools],
    tables: %w[app tables]
  }.freeze

  class NotAuthorizedError < StandardError; end

  class NoPolicyError < StandardError; end

  class MissingGemError < StandardError; end
end

loader.eager_load
