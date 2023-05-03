# frozen_string_literal: true
# requires all dependencies
Gem.loaded_specs['table_gen'].dependencies.each do |d|
  case d.name
  when 'activerecord'
    require 'active_record/railtie'
  when 'actionview'
    require 'action_view/railtie'
  when 'activestorage'
    require 'active_storage/engine'
  when 'actiontext'
    require 'action_text/engine'
  else
    require d.name
  end
end

# In development we should load the engine so we get the autoload for components
require 'view_component/engine' if ENV['RAILS_ENV'] === 'development'

module TableGen
  class Engine < ::Rails::Engine
    isolate_namespace TableGen

    config.after_initialize do
      # Boot TableGen
      ::TableGen::App.boot
    end

    initializer 'table_gen.autoload' do |app|
      TableGen::ENTITIES.each_value do |path_params|
        path = Rails.root.join(*path_params)

        Rails.autoloaders.main.push_dir path.to_s if File.directory? path.to_s
      end
    end

    initializer 'table_gen.init_columns' do |app|
      # Init the columns
      ::TableGen::App.init_columns
    end

    initializer 'table_gen.reloader' do |app|
      TableGen::Reloader.new.tap do |reloader|
        reloader.execute
        app.reloaders << reloader
        app.reloader.to_run { reloader.execute }
      end
    end

    initializer 'debug_exception_response_format' do |app|
      app.config.debug_exception_response_format = :api
      # app.config.logger = ::Logger.new(STDOUT)
    end

    initializer 'table_gen.test_buddy' do |app|
      Rails.autoloaders.main.push_dir TableGen::Engine.root.join('spec', 'helpers') if TableGen::IN_DEVELOPMENT
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ['/table_gen-assets'],
      root: TableGen::Engine.root.join('public')
    )

    config.generators do |g|
      g.test_framework :rspec, view_specs: false
    end

    generators do |app|
      Rails::Generators.configure! app.config.generators
      require_relative '../generators/model_generator'
    end
  end
end
