require "fileutils"
require_relative "named_base_generator"

module Generators
  module TableGen
    class TableToolGenerator < NamedBaseGenerator
      source_root File.expand_path("templates", __dir__)

      argument :name, type: :string, required: true

      namespace "table_gen:table_tool"

      def handle
        # Add configuration file
        template "table_tools/table_tool.tt", "app/table_gen/table_tools/#{file_name}.rb"

        # Add view file
        template "table_tools/partial.tt", "app/views/table_gen/table_tools/_#{file_name}.html.erb"
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
