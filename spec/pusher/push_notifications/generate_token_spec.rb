# frozen_string_literal: true

require 'spec_helper'
require 'jwt'

RSpec.describe Pusher::PushNotifications, '.generate_token' do
  def generate_token
    described_class.generate_token(user: user)
  end

  let(:user) { 'Elmo' }
  let(:instance_id) { described_class.instance_id }
  let(:secret_key) { described_class.secret_key }

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
    max_user_id_length = Pusher::PushNotifications::UserId::MAX_USER_ID_LENGTH
    let(:user) { 'a' * (max_user_id_length + 1) }

    it 'user deletion request will fail' do
      expect { generate_token }.to raise_error(
        Pusher::PushNotifications::UseCases::GenerateToken::GenerateTokenError
      ).with_message(
        'User id length too long (expected fewer than 165 characters)'
      )
    end
  end

  context 'when user id is valid' do
    it 'will generate valid token' do
      expect do
        JWT.decode generate_token['token'], secret_key, true
      end.to_not raise_error
    end
    it 'will contain user id in the \'sub\' (subject) claim' do
      decoded_token = JWT.decode generate_token['token'], nil, false
      expect(decoded_token.first['sub']).to eq(user)
    end
  end
end
