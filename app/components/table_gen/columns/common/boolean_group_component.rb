# frozen_string_literal: true

class TableGen::Columns::Common::BooleanGroupComponent < ViewComponent::Base
  def initialize(options: {}, value: nil)
    @options = options
    @value = value
  end
end
