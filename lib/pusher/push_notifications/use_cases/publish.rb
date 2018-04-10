# frozen_string_literal: true

require 'caze'

module Pusher
  module PushNotifications
    module UseCases
      class Publish
        include Caze

        class PublishError < RuntimeError; end

        export :call, as: :publish

        def initialize(interests:, payload: {})
          valid_interest_pattern = /^(_|\-|=|@|,|\.|:|[A-Z]|[a-z]|[0-9])*$/

          interests.each do |interest|
            if (interest_valid = !valid_interest_pattern.match(interest))
              raise PublishError, "Invalid interest name \nMax 164 characters and can only contain ASCII upper/lower-case letters, numbers or one of _-=@,.:"
            end
          end

          raise PublishError, 'Must provide at least one interest' if interests.length == 0
          raise PublishError, "Number of interests #{interests.length} exceeds maximum of 100" if interests.length > 100

          @interests = interests
          @payload = payload
        end

        def call
          data = { interests: interests }.merge!(payload)
          client.post('publishes', data)
        end

        private

        attr_reader :interests, :payload

        def client
          @_client ||= PushNotifications::Client.new
        end
      end
    end
  end
end
