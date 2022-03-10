# frozen_string_literal: true

module Pusher
  module PushNotifications
    module UseCases
      class PublishToUsers
        class UsersPublishError < RuntimeError; end

        # Publish the given payload to the specified users.
        def self.publish_to_users(client, users:, payload: {})
          users.each do |user|
            raise UsersPublishError, 'User Id cannot be empty.' if user.empty?

            next unless user.length > UserId::MAX_USER_ID_LENGTH

            raise UsersPublishError, 'User id length too long ' \
            "(expected fewer than #{UserId::MAX_USER_ID_LENGTH + 1}" \
            ' characters)'
          end

          raise UsersPublishError, 'Must supply at least one user id.' if users.count < 1

          if users.length > UserId::MAX_NUM_USER_IDS
            raise UsersPublishError, "Number of user ids #{users.length} "\
            "exceeds maximum of #{UserId::MAX_NUM_USER_IDS}."
          end

          data = { users: users }.merge!(payload)
          client.post('publishes/users', data)
        end
      end
    end
  end
end
