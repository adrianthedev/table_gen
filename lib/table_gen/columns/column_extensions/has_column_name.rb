# frozen_string_literal: true
module TableGen
  module Columns
    module ColumnExtensions
      module HasColumnName
        # Set the column name
        def column_name(name)
          self.column_name_attribute = name
        end

        # Get the column name
        def get_column_name
          return column_name_attribute if column_name_attribute.present?

          to_s.demodulize.underscore.gsub '_column', ''
        end
      end
    end
  end
end
