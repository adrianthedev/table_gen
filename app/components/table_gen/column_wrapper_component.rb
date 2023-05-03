# frozen_string_literal: true

module TableGen
  class ColumnWrapperComponent < ViewComponent::Base
    attr_reader :dash_if_blank, :compact, :column, :form, :full_width, :table

    def initialize(
      dash_if_blank: true,
      data: {},
      compact: false,
      help: nil, # do we really need it?
      column: nil,
      form: nil,
      full_width: false,
      label: nil, # do we really need it?
      table: nil,
      stacked: nil,
      style: '',
      **args
    )
      super
      @args = args
      @classes = args[:class].present? ? args[:class] : ''
      @dash_if_blank = dash_if_blank
      @data = data
      @compact = compact
      @help = help
      @column = column
      @form = form
      @full_width = full_width
      @label = label
      @table = table
      @stacked = stacked
      @style = style
    end

    def classes(extra_classes = '')
      "column-wrapper relative flex flex-col flex-grow pb-2 md:pb-0 leading-tight min-h-14 #{stacked? ? 'column-wrapper-layout-stacked' : 'column-wrapper-layout-inline md:flex-row md:items-center'} #{compact? ? 'column-wrapper-size-compact' : 'column-wrapper-size-regular'} #{full_width? ? 'column-width-full' : 'column-width-regular'} #{@classes || ''} #{extra_classes || ''} #{@column.get_html(
        :classes, element: :wrapper
      )}"
    end

    def style
      "#{@style} #{@column.get_html(:style, element: :wrapper)}"
    end

    def label
      @label || @column.name
    end

    def help
      help_value = @help || @column.help

      if help_value.respond_to?(:call)
        return TableGen::Hosts::TableViewRecordHost.new(block: help_value, record: record, table: table).handle
      end

      help_value
    end

    def record
      table.present? ? table.model : nil
    end

    def data
      attributes = {
        column_id: @column.id,
        column_type: @column.type,
        **@data
      }

      # Add the built-in stimulus integration data tags.
      if @table.present?
        @table.get_stimulus_controllers.split(' ').each do |controller|
          attributes["#{controller}-target"] =
            "#{@column.id.to_s.underscore}_#{@column.type.to_s.underscore}_wrapper".camelize(:lower)
        end
      end

      # Fetch the data attributes off the html option
      wrapper_data_attributes = @column.get_html :data, element: :wrapper
      attributes.merge! wrapper_data_attributes if wrapper_data_attributes.present?

      attributes
    end

    def stacked?
      # Override on the declaration level
      return @stacked unless @stacked.nil?

      # Fetch it from the column
      return column.stacked unless column.stacked.nil?

      # Fallback to defaults
      TableGen.configuration.column_wrapper_layout == :stacked
    end

    def compact?
      @compact
    end

    def full_width?
      @full_width
    end
  end
end
