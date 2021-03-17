# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications, '.delete_user' do
  def delete_user
    Pusher::PushNotifications.delete_user(user: user)
  end

  let(:user) { "Stop!' said Fred user" }

  context 'when user id is empty' do
    let(:user) { '' }

    it 'user deletion request will fail' do
      expect { delete_user }.to raise_error(
        Pusher::PushNotifications::UseCases::DeleteUser::UserDeletionError
      ).with_message(
        'User Id cannot be empty.'
      )
    end
  end

  context 'when user id is too long' do
    max_user_id_length = Pusher::PushNotifications::UserId::MAX_USER_ID_LENGTH
    let(:user) { 'a' * (max_user_id_length + 1) }

    it 'user deletion request will fail' do
      expect { delete_user }.to raise_error(
        Pusher::PushNotifications::UseCases::DeleteUser::UserDeletionError
      ).with_message(
        'User id length too long (expected fewer than 165 characters)'
      )
    end
  end

  context 'when user id is valid' do
    it 'will delete the user' do
      VCR.use_cassette('delete/user') do
        response = delete_user

        expect(response).to be_ok
      end
    end
  end
end
