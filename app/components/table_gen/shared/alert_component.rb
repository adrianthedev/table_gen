# frozen_string_literal: true

module TableGen
  module Shared
    # main alert component
    class AlertComponent < ViewComponent::Base
      include TableGen::ApplicationHelper

      attr_reader :type, :message

      def initialize(type, message)
        super
        @type = type
        @message = message
      end

      def icon
        return 'heroicons/solid/x-circle' if error?
        return 'heroicons/solid/exclamation' if warning?
        return 'heroicons/solid/exclamation-circle' if info?
        return 'heroicons/solid/check-circle' if success?

        'check-circle'
      end

      def classes
        return 'hidden' if empty?

        result = 'max-w-lg w-full shadow-lg rounded px-4 py-3 rounded relative border text-white pointer-events-auto'

        if error?
          "#{result} bg-red-400 border-red-600"
        elsif success?
          "#{result}  bg-green-500 border-green-600"
        elsif warning?
          "#{result}  bg-orange-400 border-orange-600"
        elsif info?
          "#{result}  bg-blue-400 border-blue-600"
        end
      end

      def error?
        type.to_sym == :error || type.to_sym == :alert
      end

      def success?
        type.to_sym == :success
      end

      def info?
        type.to_sym == :notice || type.to_sym == :info
      end

      def warning?
        type.to_sym == :warning
      end

      def empty?
        message.nil?
      end
    end
  end
end
