# frozen_string_literal: true

module TableGen
  module Columns
    class FilesColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args) do
          "#{@column.value.attachments.length} files"
        end
      end
    end
  end
end
