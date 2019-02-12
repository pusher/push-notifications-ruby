# frozen_string_literal: true

require 'jwt'

module Pusher
  module PushNotifications
    class Token
      def generate(user)
        exp = Time.now.to_i + 24 * 60 * 60 # Current time + 24h
        secret_token = ENV['PUSHER_SECRET_KEY']
        instance_id = ENV['PUSHER_INSTANCE_ID']
        iss = "https://#{instance_id}.pushnotifications.pusher.com"
        payload = { 'sub' => user, 'exp' => exp, 'iss' => iss }
        JWT.encode payload, secret_token, 'HS256'
      end
    end
  end
end
