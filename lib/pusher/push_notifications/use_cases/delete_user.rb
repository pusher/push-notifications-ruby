# frozen_string_literal: true

require 'caze'

module Pusher
  module PushNotifications
    module UseCases
      class DeleteUser
        include Caze

        class UserDeletionError < RuntimeError; end

        export :delete_user, as: :delete_user

        def initialize(user:)
          @user = user
          @user_id = Pusher::PushNotifications::UserId.new

          raise UserDeletionError, 'User Id cannot be empty.' if user.empty?
          if user.length > UserId::MAX_USER_ID_LENGTH
            raise UserDeletionError, 'User id length too long ' \
            "(expected fewer than #{UserId::MAX_USER_ID_LENGTH + 1} characters)"
          end
        end

        # Contacts the Beams service
        # to remove all the devices of the given user.
        def delete_user
          client.delete(user)
        end

        private

        attr_reader :user

        def client
          @client ||= PushNotifications::Client.new
        end
      end
    end
  end
end
