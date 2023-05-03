# frozen_string_literal: true

module TableGen
  module Columns
    class IdColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, class: 'whitespace-no-wrap w-[1%]') do
          link_to_if (@column.link_to_table or TableGen.configuration.id_links_to_table),
                     @column.value, table_view_path,
                     title: t('avo.view_item', item: @table.name).humanize
        end
      end
    end
  end
end
