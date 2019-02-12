# frozen_string_literal: true

require 'caze'

module Pusher
  module PushNotifications
    module UseCases
      class GenerateToken
        include Caze

        class GenerateTokenError < RuntimeError; end

        export :generate_token, as: :generate_token

        def initialize(user:)
          raise GenerateTokenError, 'User Id cannot be empty.' if user.empty?
          raise GenerateTokenError, "Number of user ids #{user.length} exceeds maximum of #{max_num_user_ids}." if user.length > max_user_id_length

          @user = user
        end

        # Creates a signed JWT for a user id.
        def generate_token
          { 'token' => jwt_token.generate(user) }
        end

        private

        attr_reader :user

        def jwt_token
          @jwt_token ||= PushNotifications::Token.new
        end

        def max_user_id_length
          Pusher::PushNotifications::MAX_USER_ID_LENGTH
        end

        def max_num_user_ids
          Pusher::PushNotifications::MAX_NUM_USER_IDS
        end
      end
    end
  end
end
