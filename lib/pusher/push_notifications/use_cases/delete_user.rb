# frozen_string_literal: true

module Pusher
  module PushNotifications
    module UseCases
      class DeleteUser
        class UserDeletionError < RuntimeError; end

        # Contacts the Beams service
        # to remove all the devices of the given user.
        def self.delete_user(client, user:)
          raise UserDeletionError, 'User Id cannot be empty.' if user.empty?

          if user.length > UserId::MAX_USER_ID_LENGTH
            raise UserDeletionError, 'User id length too long ' \
            "(expected fewer than #{UserId::MAX_USER_ID_LENGTH + 1} characters)"
          end

          client.delete(user)
        end
      end
    end
  end
end
