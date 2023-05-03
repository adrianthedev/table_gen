# frozen_string_literal: true

module TableGen
  module Columns
    class FileColumnComponent < TableGen::Columns::IndexComponent
      def call
        index_column_wrapper(**column_wrapper_args, flush: flush?) do
          if @column.value.present?
            link = link_to_table if @column.link_to_table
            tag_options = { class: 'block' }
            tag_options[:class] += ' h-8' if has_audio_tag?

            if has_image_tag?
              image_tag = image_tag(helpers.main_app.url_for(@column.value), class: 'h-10')
              link_to_if(@column.link_to_table, image_tag, link, tag_options)
            elsif has_audio_tag?
              audio_tag = audio_tag(
                helpers.main_app.url_for(@column.value),
                controls: true,
                preload: false,
                class: 'max-h-full h-10'
              )
              link_to_if(@column.link_to_table, audio_tag, link, tag_options)
            else
              @column.value.filename
            end

          else
            '—'
          end
        end
      end

      private

      def link_to_table
        table_view_path
      end

      def flush?
        has_image_tag? || has_audio_tag?
      end

      def has_image_tag?
        @column.value.attached? && @column.value.representable? && @column.is_image
      end

      def has_audio_tag?
        @column.value.attached? && @column.is_audio
      end
    end
  end
end
