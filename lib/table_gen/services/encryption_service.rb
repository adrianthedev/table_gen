# frozen_string_literal: true
module TableGen
  module Services
    class EncryptionService
      attr_reader :message, :purpose, :crypt

      class << self
        def encrypt(message:, purpose:)
          new(message: message, purpose: purpose).encrypt
        end

        def decrypt(message:, purpose:)
          new(message: message, purpose: purpose).decrypt
        end
      end

      def initialize(message:, purpose:)
        @message = message
        @purpose = purpose
        @crypt = ActiveSupport::MessageEncryptor.new(encryption_key)
      end

      def encrypt
        crypt.encrypt_and_sign(message, purpose: purpose)
      end

      def decrypt
        crypt.decrypt_and_verify(message, purpose: purpose)
      end

      private

      def encryption_key
        secret_key_base[0..31]
      rescue StandardError
        # This will fail the decryption process.
        # It's here only to keep TableGen from crashing
        SecureRandom.random_bytes(32)
      end

      def secret_key_base
        ENV['SECRET_KEY_BASE'] || Rails.application.credentials.secret_key_base || Rails.application.secrets.secret_key_base
      end
    end
  end
end
