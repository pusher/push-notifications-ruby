# frozen_string_literal: true

require 'caze'
require 'forwardable'

module Pusher
  module PushNotifications
    module UseCases
      class GenerateToken
        include Caze
        extend Forwardable

        class GenerateTokenError < RuntimeError; end

        export :generate_token, as: :generate_token

        def initialize(user:)
          @user = user
          @user_id = Pusher::PushNotifications::UserId.new

          raise GenerateTokenError, 'User Id cannot be empty.' if user.empty?
          raise GenerateTokenError, "Number of user ids #{user.length} exceeds maximum of #{max_num_user_ids}." if user.length > max_user_id_length
        end

        # Creates a signed JWT for a user id.
        def generate_token
          { 'token' => jwt_token.generate(user) }
        end

        private

        attr_reader :user, :user_id
        def_delegators :@user_id, :max_user_id_length, :max_num_user_ids

        def jwt_token
          @jwt_token ||= PushNotifications::Token.new
        end
      end
    end
  end
end
