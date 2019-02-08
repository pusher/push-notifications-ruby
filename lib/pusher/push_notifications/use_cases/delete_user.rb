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
          raise UserDeletionError, 'User Id cannot be empty.' if user.empty?
          raise UserDeletionError, "Number of user ids #{user.length} exceeds maximum of #{max_num_user_ids}." if user.length > max_user_id_length

          @user = user
        end

        # Contacts the Beams service to remove all the devices of the given user.
        def delete_user
          client.delete("users/#{user}")
        end

        private

        attr_reader :user

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
