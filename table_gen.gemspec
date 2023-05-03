# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'table_gen/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name = 'table_gen'
  spec.version = TableGen::VERSION
  spec.authors = ['Ahmadshoh Nasrullozoda']
  spec.email = ['tajbrains@gmail.com']
  spec.homepage = 'https://tajbrains.com'
  spec.summary = 'Configuration-based, no-maintenance, extendable Ruby on Rails table generator.'
  spec.description = "This gem provides a simple and efficient way to generate tables with just a single line of code. It allows Rails developers to easily create tables for their applications without having to write repetitive and time-consuming HTML and CSS code. The gem includes a variety of customization options, such as the ability to specify column headings, data types, sorting, and filtering. It also includes support for pagination, which allows developers to display large datasets in a user-friendly way. With this gem, Rails developers can save time and effort by quickly generating tables that look great and are easy to use."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['bug_tracker_uri'] = 'https://github.com/tajbrains/'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.required_ruby_version = '>= 2.6.0'
  spec.post_install_message = 'Thank you for using TableGen 💪  Docs are available at TODO:'

  spec.files = Dir['{bin,app,config,db,lib,public}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md', 'table_gen.gemspec', 'Gemfile', 'Gemfile.lock']

  spec.add_dependency 'actionview', '>= 6.0'
  spec.add_dependency 'active_link_to'
  spec.add_dependency 'activerecord', '>= 6.0'
  spec.add_dependency 'addressable'
  spec.add_dependency 'docile'
  spec.add_dependency 'dry-initializer'
  spec.add_dependency 'httparty'
  spec.add_dependency 'inline_svg'
  spec.add_dependency 'meta-tags'
  spec.add_dependency 'pagy'
  spec.add_dependency 'turbo-rails'
  spec.add_dependency 'view_component'
  spec.add_dependency 'zeitwerk', '>= 2.6.2'
end
