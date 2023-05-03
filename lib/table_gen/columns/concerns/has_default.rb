module TableGen
  module Columns
    module Concerns
      module HasDefault
        extend ActiveSupport::Concern

        def computed_default_value
          if default.respond_to? :call
            TableGen::Hosts::TableViewRecordHost.new(block: default, record: model, table: table).handle
          else
            default
          end
        end
      end
    end
  end
end
