# frozen_string_literal: true

class TableGen::Columns::Common::StatusViewerComponent < ViewComponent::Base
  include TableGen::ApplicationHelper

  def initialize(status:, label:)
    super
    @status = status
    @label = label
  end
end
