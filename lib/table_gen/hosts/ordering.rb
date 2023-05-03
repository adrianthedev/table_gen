# frozen_string_literal: true

require 'dry-initializer'

module TableGen
  module Hosts
    class Ordering
      extend Dry::Initializer

      option :options, default: proc { {} }
      option :table
      option :record, default: proc { table.model }
      option :params, default: proc { table.params }

      def order(direction)
        action = options.dig(:actions, direction.to_sym)

        return unless action.present?

        instance_exec(&action)
      end
    end
  end
end
