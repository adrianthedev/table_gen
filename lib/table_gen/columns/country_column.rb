# frozen_string_literal: true
module TableGen
  module Columns
    class CountryColumn < BaseColumn
      include TableGen::Columns::ColumnExtensions::HasIncludeBlank

      attr_reader :countries
      attr_reader :display_code

      def initialize(id, **args, &block)
        args[:placeholder] ||= I18n.t('avo.choose_a_country')

        super(id, **args, &block)

        @countries = begin
          ISO3166::Country.translations.sort_by { |code, name| name }.to_h
        rescue StandardError
          {none: 'You need to install the countries gem for this column to work properly'}
        end
        @display_code = args[:display_code].present? ? args[:display_code] : false
      end

      def select_options
        if @display_code
          countries.map do |code, name|
            [code, code]
          end
        else
          countries.map do |code, name|
            [name, code]
          end
        end
      end
    end
  end
end
