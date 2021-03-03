# frozen_string_literal: true

module Pusher
  module PushNotifications
    module UseCases
      class GenerateToken
        class GenerateTokenError < RuntimeError; end

        class << self
          def generate_token(*args, **kwargs)
            new(*args, **kwargs).generate_token
          end
        end

        def initialize(user:)
          @user = user
          @user_id = Pusher::PushNotifications::UserId.new

          raise GenerateTokenError, 'User Id cannot be empty.' if user.empty?
          if user.length > UserId::MAX_USER_ID_LENGTH
            raise GenerateTokenError, 'User id length too long ' \
            "(expected fewer than #{UserId::MAX_USER_ID_LENGTH + 1} characters)"
          end
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
      end
    end
  end
end
