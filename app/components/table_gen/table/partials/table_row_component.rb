# frozen_string_literal: true

module TableGen
  module Table
    module Partials
      class TableRowComponent < ViewComponent::Base
        include TableGen::TablesHelper
        include TableGen::ApplicationHelper

        def initialize(table: nil)
          super
          @table = table
        end
      end
    end
  end
end
