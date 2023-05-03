# frozen_string_literal: true

module TableGen
  module Columns
    class GravatarColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, flush: true) do
          render TableGen::Columns::Common::GravatarViewerComponent.new(
            md5: @column.md5,
            default: @column.default,
            size: @column.size,
            rounded: @column.rounded,
            link_to_table: @column.link_to_table,
            link: table_view_path,
            title: t('avo.view_item', item: @table.name).humanize
          )
        end
      end
    end
  end
end
