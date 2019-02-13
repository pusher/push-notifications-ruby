# frozen_string_literal: true

require 'spec_helper'
require 'jwt'

RSpec.describe Pusher::PushNotifications::UseCases::GenerateToken do
  subject(:use_case) { described_class.new(user: user) }

  let(:user) { 'Elmo' }
  let(:instance_id) { ENV['PUSHER_INSTANCE_ID'] }
  let(:secret_key) { ENV['PUSHER_SECRET_KEY'] }

  describe '#generate_token' do
    subject(:generate_token) { use_case.generate_token }

    context 'when user id is empty' do
      let(:user) { '' }

      it 'token generation will fail' do
        expect { generate_token }.to raise_error(
          Pusher::PushNotifications::UseCases::GenerateToken::GenerateTokenError
        ).with_message(
          'User Id cannot be empty.'
        )
      end
    end

    context 'when user id is too long' do
      let(:user) { 'a' * 165 }

      it 'user deletion request will fail' do
        expect { generate_token }.to raise_error(
          Pusher::PushNotifications::UseCases::GenerateToken::GenerateTokenError
        ).with_message(
          'User id length too long (expected fewer than 165 characters)'
        )
      end
    end

    context 'when user id is valid' do
      it 'will generate the token' do
        exp = Time.now.to_i + 24 * 60 * 60 # Current time + 24h
        iss = "https://#{instance_id}.pushnotifications.pusher.com"
        payload = { 'sub' => user, 'exp' => exp, 'iss' => iss }
        expected_token = JWT.encode payload, secret_key, 'HS256'
        expect(generate_token['token']).to eq(expected_token)
      end
    end
  end
end
