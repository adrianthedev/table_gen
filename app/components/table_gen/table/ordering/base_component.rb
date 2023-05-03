# frozen_string_literal: true

class TableGen::Table::Ordering::BaseComponent < TableGen::BaseComponent
  private

  def order_actions
    @table.class.order_actions
  end
end
