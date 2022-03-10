# frozen_string_literal: true

module Pusher
  module PushNotifications
    module UseCases
      class GenerateToken
        class GenerateTokenError < RuntimeError; end

        # Creates a signed JWT for a user id.
        def self.generate_token(user:)
          raise GenerateTokenError, 'User Id cannot be empty.' if user.empty?

          if user.length > UserId::MAX_USER_ID_LENGTH
            raise GenerateTokenError, 'User id length too long ' \
            "(expected fewer than #{UserId::MAX_USER_ID_LENGTH + 1} characters)"
          end

          jwt_token = PushNotifications::Token.new

          { 'token' => jwt_token.generate(user) }
        end
      end
    end
  end
end
