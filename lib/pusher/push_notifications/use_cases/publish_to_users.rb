# frozen_string_literal: true

require 'caze'

module Pusher
  module PushNotifications
    module UseCases
      class PublishToUsers
        include Caze

        class UsersPublishError < RuntimeError; end

        export :publish_to_users, as: :publish_to_users

        def initialize(users:, payload: {})
          @users = users
          @user_id = Pusher::PushNotifications::UserId.new
          @payload = payload

          users.each do |user|
            raise UsersPublishError, 'User Id cannot be empty.' if user.empty?

            next unless user.length > UserId::MAX_USER_ID_LENGTH
            raise UsersPublishError, 'User id length too long ' \
            "(expected fewer than #{UserId::MAX_USER_ID_LENGTH + 1}" \
            ' characters)'
          end

          if users.count < 1
            raise UsersPublishError, 'Must supply at least one user id.'
          end
          if users.length > UserId::MAX_NUM_USER_IDS
            raise UsersPublishError, "Number of user ids #{users.length} "\
            "exceeds maximum of #{UserId::MAX_NUM_USER_IDS}."
          end
        end

        # Publish the given payload to the specified users.
        def publish_to_users
          data = { users: users }.merge!(payload)
          client.post('publishes/users', data)
        end

        private

        attr_reader :users, :payload

        def client
          @client ||= PushNotifications::Client.new
        end
      end
    end
  end
end
