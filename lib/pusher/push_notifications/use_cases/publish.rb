# frozen_string_literal: true

module Pusher
  module PushNotifications
    module UseCases
      class Publish
        class PublishError < RuntimeError; end

        # Publish the given payload to the specified interests.
        # <b>DEPRECATED:</b> Please use <tt>publish_to_interests</tt> instead.
        def self.publish(client, interests:, payload: {})
          warn "[DEPRECATION] `publish` is deprecated. \
Please use `publish_to_interests` instead."
          publish_to_interests(client, interests: interests, payload: payload)
        end

        # Publish the given payload to the specified interests.
        def self.publish_to_interests(client, interests:, payload: {})
          valid_interest_pattern = /^(_|-|=|@|,|\.|:|[A-Z]|[a-z]|[0-9])*$/

          interests.each do |interest|
            next if valid_interest_pattern.match?(interest)

            raise PublishError,
                  "Invalid interest name \nMax #{UserId::MAX_USER_ID_LENGTH}" \
                  ' characters and can only contain ASCII upper/lower-case' \
                  ' letters, numbers or one of _-=@,.:'
          end

          raise PublishError, 'Must provide at least one interest' if interests.empty?

          if interests.length > 100
            raise PublishError, "Number of interests #{interests.length}" \
            ' exceeds maximum of 100'
          end

          data = { interests: interests }.merge!(payload)
          client.post('publishes', data)
        end
      end
    end
  end
end
