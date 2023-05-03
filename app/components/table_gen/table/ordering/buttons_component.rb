# frozen_string_literal: true

class TableGen::Table::Ordering::ButtonsComponent < TableGen::Table::Ordering::BaseComponent
  def initialize(table: nil)
    super
    @table = table
  end

  def render?
    can_order_any? && enabled_in_view?
  end

  private

  def can_order_any?
    order_actions.present?
  end

  def display_inline?
    ordering[:display_inline]
  end

  def enabled_in_view?
    visible_on_option.include? :index
  end

  def visible_on_option
    return [] if ordering.nil?

    [ordering[:visible_on]].flatten
  end

  def ordering
    @table.class.ordering
  end
end
