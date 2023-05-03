module TableGen
  module Columns
    # i have no idea for it is
    class BadgeColumn < BaseColumn
      attr_reader :options

      def initialize(id, **args, &block)
        super(id, **args, &block)

        default_options = {info: :info, success: :success, danger: :danger, warning: :warning}
        @options = args[:options].present? ? default_options.merge(args[:options]) : default_options
      end
    end
  end
end
