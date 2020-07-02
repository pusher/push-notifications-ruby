# frozen_string_literal: true

require 'caze'

require_relative './push_notifications/client'
require_relative './push_notifications/use_cases/publish'
require_relative './push_notifications/use_cases/publish_to_users'
require_relative './push_notifications/use_cases/delete_user'
require_relative './push_notifications/use_cases/generate_token'
require_relative './push_notifications/version'
require_relative './push_notifications/user_id'
require_relative './push_notifications/token'

module Pusher
  module PushNotifications
    include Caze

    class PushError < RuntimeError; end

    has_use_case :publish, UseCases::Publish
    has_use_case :publish_to_interests, UseCases::Publish
    has_use_case :publish_to_users, UseCases::PublishToUsers
    has_use_case :delete_user, UseCases::DeleteUser
    has_use_case :generate_token, UseCases::GenerateToken

    class << self
      attr_reader :instance_id, :secret_key

      def configure
        yield(self)
        # returning a duplicate of `self` to allow multiple clients to be
        # configured without needing to reconfigure the singleton instance
        dup
      end

      def instance_id=(instance_id)
        if instance_id.nil? || instance_id.delete(' ').empty?
          raise PushError, 'Invalid instance id'
        end
        @instance_id = instance_id
      end

      def secret_key=(secret_key)
        if secret_key.nil? || secret_key.delete(' ').empty?
          raise PushError, 'Invalid secret key'
        end
        @secret_key = secret_key
      end

      def endpoint=(endpoint)
        if !endpoint.nil? && endpoint.delete(' ').empty?
          raise PushError, 'Invalid endpoint override'
        end

        @endpoint = endpoint
      end

      def endpoint
        return @endpoint unless @endpoint.nil?

        "https://#{@instance_id}.pushnotifications.pusher.com"
      end
    end
  end
end
