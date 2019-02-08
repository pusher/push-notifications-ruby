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
          users.each do |user|
            if user.length > max_user_id_length
              raise UsersPublishError, "User id length too long (expected fewer than #{max_user_id_length + 1} characters)"
            end
          end

          raise UsersPublishError, 'Must supply at least one user id.' if users.count < 1
          raise UsersPublishError, "Number of user ids #{users.length} exceeds maximum of #{max_num_user_ids}." if users.length > max_num_user_ids
          raise UsersPublishError, 'Empty user ids are not valid.' if users.include? ''

          @users = users
          @payload = payload
        end

        # Publish the given payload to the specified users.
        def publish_to_users
          data = { users: users }.merge!(payload)
          client.post('publishes/users', data)
        end

        private

        attr_reader :users, :payload

        def max_num_user_ids
          1000
        end

        # Separate this and reuse since it's used here and in delete user!
        def max_user_id_length
          164
        end

        def client
          @client ||= PushNotifications::Client.new
        end
      end
    end
  end
end
