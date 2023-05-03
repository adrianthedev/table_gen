# frozen_string_literal: true
require_relative 'base_generator'

module Generators
  module TableGen
    class EjectGenerator < BaseGenerator
      argument :filename, type: :string, required: true

      source_root ::TableGen::Engine.root

      namespace 'table_gen:eject'

      TEMPLATES = {
        head: 'app/views/table_gen/partials/_head.html.erb',
        pre_head: 'app/views/table_gen/partials/_pre_head.html.erb',
        scripts: 'app/views/table_gen/partials/_scripts.html.erb'
      }.freeze

      def handle
        if @filename.starts_with?(':')
          template_id = path_to_sym @filename
          template_path = TEMPLATES[template_id]

          if path_exists? template_path
            eject template_path
          else
            say("Failed to find the `#{template_id.to_sym}` template.", :yellow)
          end
        elsif path_exists? @filename
          eject @filename
        else
          say("Failed to find the `#{@filename}` template.", :yellow)
        end
      end

      no_tasks do
        def path_to_sym(filename)
          template_id = filename.dup
          template_id[0] = ''
          template_id.to_sym
        end

        def path_exists?(path)
          path.present? && File.file?(::TableGen::Engine.root.join(path))
        end

        def eject(path)
          copy_file ::TableGen::Engine.root.join(path), ::Rails.root.join(path)
        end
      end
    end
  end
end
