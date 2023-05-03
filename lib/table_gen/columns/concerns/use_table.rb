module TableGen
  module Columns
    module Concerns
      module UseTable
        extend ActiveSupport::Concern

        def use_table
          App.get_table @use_table
        end
      end
    end
  end
end
