require_relative "../base_generator"

module Generators
  module TableGen
    module Tailwindcss
      class InstallGenerator < BaseGenerator
        source_root File.expand_path("../templates", __dir__)

        namespace "table_gen:tailwindcss:install"
        desc "Add Tailwindcss to your TableGen project."

        def create_files
          unless tailwindcss_installed?
            system "./bin/bundle add tailwindcss-rails"
            system "./bin/rails tailwindcss:install"
          end

          unless Rails.root.join("app", "assets", "stylesheets", "table_gen.tailwind.css").exist?
            say "Add default app/assets/stylesheets/table_gen.tailwind.css"
            copy_file template_path("table_gen.tailwind.css"), "app/assets/stylesheets/table_gen.tailwind.css"
          end

          if Rails.root.join("Procfile.dev").exist?
            append_to_file "Procfile.dev", "avo_css: bin/rails table_gen:tailwindcss:watch\n"
          else
            say "Add default Procfile.dev"
            copy_file template_path("Procfile.dev"), "Procfile.dev"

            say "Ensure foreman is installed"
            run "gem install foreman"
          end

          # Ensure that the _pre_head.html.erb template is available
          unless Rails.root.join("app", "views", "table_gen", "partials", "_pre_head.html.erb").exist?
            say "Ejecting the _pre_head.html.erb partial"
            Rails::Generators.invoke("table_gen:eject", [":pre_head", "--skip-table_gen-version"], {destination_root: Rails.root})
          end

          say "Adding the CSS asset to the partial"
          prepend_to_file Rails.root.join("app", "views", "table_gen", "partials", "_pre_head.html.erb"), "<%= stylesheet_link_tag \"table_gen.tailwind.css\", media: \"all\" %>"
        end

        no_tasks do
          def template_path(filename)
            Pathname.new(__dir__).join("..", "templates", "tailwindcss", filename).to_s
          end

          def tailwindcss_installed?
            Rails.root.join("config", "tailwind.config.js").exist? || Rails.root.join("tailwind.config.js").exist?
          end
        end
      end
    end
  end
end
