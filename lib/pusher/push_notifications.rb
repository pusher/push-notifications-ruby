# frozen_string_literal: true

require 'pusher/push_notifications/client'
require 'pusher/push_notifications/version'

module Pusher
  module PushNotifications
    class PushError < RuntimeError; end

    class << self
      attr_accessor :instance_id, :secret_key

      def configure
        yield(self)
        self
      end

      def instance_id=(instance_id)
        if instance_id.nil? || instance_id.gsub(' ', '').empty?
          raise PushError, 'Invalid instance id'
        end
        @instance_id = instance_id
      end

      def secret_key=(secret_key)
        if secret_key.nil? || secret_key.gsub(' ', '').empty?
          raise PushError, 'Invalid secret key'
        end
        @secret_key = secret_key
      end
    end
  end
end
