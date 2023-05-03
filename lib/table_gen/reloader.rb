# frozen_string_literal: true

module TableGen
  class Reloader
    delegate :execute_if_updated, :execute, :updated?, to: :updater

    def reload!
      # reload all files declared in paths
      files.each do |file|
        load file if File.exist? file
      end

      # reload all files declared in each directory
      directories.each_key do |dir|
        Dir.glob("#{dir}/**/*.rb".to_s).each do |file|
          load file if File.exist? file
        end
      end
    end

    private

    def updater
      @updater ||= config.file_watcher.new(files, directories) { reload! }
    end

    def files
      # we want to watch some files no matter what
      paths = [
        Rails.root.join('config', 'initializers', 'table_gen.rb')
      ]

      # we want to watch some files only in TableGen development
      paths += [] if reload_lib?

      paths
    end

    def directories
      dirs = {}

      # watch the lib directory in TableGen development
      dirs[TableGen::Engine.root.join('lib', 'table_gen').to_s] = ['rb'] if reload_lib?

      dirs
    end

    def config
      Rails.application.config
    end

    def reload_lib?
      TableGen::IN_DEVELOPMENT || ENV['AVO_RELOAD_LIB_DIR']
    end
  end
end
