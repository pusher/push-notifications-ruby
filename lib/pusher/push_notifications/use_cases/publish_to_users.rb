# frozen_string_literal: true

require 'caze'
require 'forwardable'

module Pusher
  module PushNotifications
    module UseCases
      class PublishToUsers
        include Caze
        extend Forwardable

        class UsersPublishError < RuntimeError; end

        export :publish_to_users, as: :publish_to_users

        def initialize(users:, payload: {})
          @users = users
          @user_id = Pusher::PushNotifications::UserId.new
          @payload = payload

          users.each do |user|
            raise UsersPublishError, 'User Id cannot be empty.' if user.empty?

            if user.length > max_user_id_length
              raise UsersPublishError, "User id length too long (expected fewer than #{max_user_id_length + 1} characters)"
            end
          end

          raise UsersPublishError, 'Must supply at least one user id.' if users.count < 1
          raise UsersPublishError, "Number of user ids #{users.length} exceeds maximum of #{max_num_user_ids}." if users.length > max_num_user_ids
        end

        # Publish the given payload to the specified users.
        def publish_to_users
          data = { users: users }.merge!(payload)
          client.post('publishes/users', data)
        end

        private

        attr_reader :users, :payload, :user_id
        def_delegators :@user_id, :max_user_id_length, :max_num_user_ids

        def client
          @client ||= PushNotifications::Client.new
        end
      end
    end
  end
end
