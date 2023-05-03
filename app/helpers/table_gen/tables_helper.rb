# frozen_string_literal: true
module TableGen
  module TablesHelper
    def table_table(tables, table)
      render partial: 'table_gen/partials/table_table', locals: {
        tables: tables,
        table: table
      }
    end

    def index_column_wrapper(**args, &block)
      render Table::ColumnWrapperComponent.new(**args) do
        capture(&block)
      end
    end

    def column_wrapper(**args, &block)
      render TableGen::ColumnWrapperComponent.new(**args) do
        capture(&block)
      end
    end

    def filter_wrapper(name: nil, index: nil, **args, &block)
      render layout: 'layouts/table_gen/filter_wrapper', locals: {
        name: name,
        index: index
      } do
        capture(&block)
      end
    end

    def item_selector_init(table)
      "data-table-name='#{table.model_key}' data-table-id='#{table.model.id}' data-controller='item-selector'"
    end

    def item_selector_input(floating: false, size: :md)
      tag :input,
          type: 'checkbox',
          name: t('avo.select_item'),
          title: t('avo.select_item'),
          class: "mx-3 rounded checked:bg-primary-400 focus:checked:!bg-primary-400 #{floating ? 'absolute inset-auto left-0 mt-3 z-10 hidden group-hover:block checked:block' : ''} #{size.to_sym == :lg ? 'w-5 h-5' : 'w-4 h-4'}",
          data: {
            action: 'input->item-selector#toggle input->item-select-all#selectRow',
            item_select_all_target: 'itemCheckbox',
            tippy: 'tooltip'
          }
    end

    def item_select_all_input
      tag :input,
          type: 'checkbox',
          name: t('avo.select_all'),
          title: t('avo.select_all'),
          class: 'mx-3 rounded w-4 h-4 checked:bg-primary-400 focus:checked:!bg-primary-400',
          data: {
            action: 'input->item-select-all#toggle',
            item_select_all_target: 'checkbox',
            tippy: 'tooltip'
          }
    end
  end
end
