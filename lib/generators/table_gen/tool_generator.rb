require "fileutils"
require_relative "base_generator"

module Generators
  module TableGen
    class ToolGenerator < BaseGenerator
      source_root File.expand_path("templates", __dir__)

      argument :name, type: :string, required: true

      namespace "table_gen:tool"

      def handle
        # Add controller if it doesn't exist
        controller_path = "app/controllers/table_gen/tools_controller.rb"
        unless File.file?(Rails.root.join(controller_path))
          template "tool/controller.tt", controller_path
        end

        # Add controller method
        inject_into_class controller_path, "TableGen::ToolsController" do
          <<-METHOD
  def #{file_name}
    @page_title = "#{human_name}"
  end
          METHOD
        end

        # Add view file
        template "tool/view.tt", "app/views/table_gen/tools/#{file_name}.html.erb"

        if ::TableGen.configuration.root_path == ""
          route <<-ROUTE
  get "#{file_name}", to: "table_gen/tools##{file_name}"
          ROUTE
        else
          route <<-ROUTE
scope :#{::TableGen.configuration.namespace} do
  get "#{file_name}", to: "table_gen/tools##{file_name}"
end
          ROUTE
        end
      end

      no_tasks do
        def file_name
          name.to_s.underscore
        end

        def controller_name
          file_name.to_s
        end

        def human_name
          file_name.humanize
        end

        def in_code(text)
          "<code class='p-1 rounded bg-gray-500 text-white text-sm'>#{text}</code>"
        end
      end
    end
  end
end
