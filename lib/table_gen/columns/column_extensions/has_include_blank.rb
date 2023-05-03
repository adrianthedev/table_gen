# frozen_string_literal: true
module TableGen
  module Columns
    module ColumnExtensions
      module HasIncludeBlank
        def include_blank
          if @args[:include_blank] == true
            placeholder || '—'
          elsif @args[:include_blank] == false
            false
          else
            @args[:include_blank]
          end
        end
      end
    end
  end
end
