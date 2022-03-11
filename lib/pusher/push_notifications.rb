# frozen_string_literal: true

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
    class PushError < RuntimeError; end

    class << self
      attr_reader :instance_id, :secret_key

      def configure
        yield(self)
        # returning a duplicate of `self` to allow multiple clients to be
        # configured without needing to reconfigure the singleton instance
        dup
      end

      def instance_id=(instance_id)
        raise PushError, 'Invalid instance id' if instance_id.nil? || instance_id.delete(' ').empty?

        @instance_id = instance_id
      end

      def secret_key=(secret_key)
        raise PushError, 'Invalid secret key' if secret_key.nil? || secret_key.delete(' ').empty?

        @secret_key = secret_key
      end

      def endpoint=(endpoint)
        raise PushError, 'Invalid endpoint override' if !endpoint.nil? && endpoint.delete(' ').empty?

        @endpoint = endpoint
      end

      def endpoint
        return @endpoint unless @endpoint.nil?

        "https://#{@instance_id}.pushnotifications.pusher.com"
      end

      def publish(interests:, payload: {})
        UseCases::Publish.publish(client, interests: interests, payload: payload)
      end

      def publish_to_interests(interests:, payload: {})
        UseCases::Publish.publish_to_interests(client, interests: interests, payload: payload)
      end

      def publish_to_users(users:, payload: {})
        UseCases::PublishToUsers.publish_to_users(client, users: users, payload: payload)
      end

      def delete_user(user:)
        UseCases::DeleteUser.delete_user(client, user: user)
      end

      def generate_token(user:)
        UseCases::GenerateToken.generate_token(user: user)
      end

      private

      def client
        @client ||= Client.new(config: self)
      end
    end
  end
end
