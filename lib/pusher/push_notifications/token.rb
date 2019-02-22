# frozen_string_literal: true

require 'jwt'

module Pusher
  module PushNotifications
    class Token
      extend Forwardable
      def initialize(config: PushNotifications)
        @config = config
      end

      def generate(user)
        exp = Time.now.to_i + 24 * 60 * 60 # Current time + 24h
        iss = "https://#{instance_id}.pushnotifications.pusher.com"
        payload = { 'sub' => user, 'exp' => exp, 'iss' => iss }
        JWT.encode payload, secret_key, 'HS256'
      end

      private

      attr_reader :config
      def_delegators :@config, :instance_id, :secret_key
    end
  end
end
