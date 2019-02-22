# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications::UseCases::PublishToUsers do
  subject(:use_case) { described_class.new(users: users, payload: payload) }

  let(:users) { %w[jonathan jordan luis luka mina] }
  let(:payload) do
    {
      apns: {
        aps: {
          alert: {
            title: 'Hello',
            body: 'Hello, world!'
          }
        }
      },
      fcm: {
        notification: {
          title: 'Hello',
          body: 'Hello, world!'
        }
      }
    }
  end

  describe '#publish_to_users' do
    subject(:publish_to_users) { use_case.publish_to_users }

    context 'when payload is malformed' do
      let(:payload) do
        { invalid: 'payload' }
      end

      it 'does not send the notification' do
        VCR.use_cassette('publishes/users/invalid_payload') do
          response = publish_to_users
          expect(response).not_to be_ok
        end
      end
    end

    context 'when payload is correct' do
      it 'sends the notification' do
        VCR.use_cassette('publishes/users/valid_payload') do
          response = publish_to_users

          expect(response).to be_ok
        end
      end
    end

    context 'when no user ids are supplied' do
      let(:users) { [] }

      it 'warns an user id array should not be empty' do
        expect { publish_to_users }.to raise_error(
          Pusher::PushNotifications::UseCases::
          PublishToUsers::UsersPublishError
        ).with_message(
          'Must supply at least one user id.'
        )
      end
    end

    context 'when user id is an empty string' do
      let(:users) { [''] }

      it 'warns an user id is invalid' do
        expect { publish_to_users }.to raise_error(
          Pusher::PushNotifications::UseCases::
          PublishToUsers::UsersPublishError
        ).with_message(
          'User Id cannot be empty.'
        )
      end
    end

    context 'when user id length is too long' do
      max_user_id_length = Pusher::PushNotifications::UserId::MAX_USER_ID_LENGTH
      user_id = 'a' * (max_user_id_length + 1)
      let(:users) { [user_id] }

      it 'warns an user id is invalid' do
        expect { publish_to_users }.to raise_error(
          Pusher::PushNotifications::UseCases::
          PublishToUsers::UsersPublishError
        ).with_message(
          'User id length too long (expected fewer than ' \
"#{max_user_id_length + 1} characters)"
        )
      end
    end

    context 'when 100 user ids are provided' do
      int_array = (1..100).to_a.shuffle
      test_users = int_array.map do |num|
        "user-#{num}"
      end

      let(:users) { test_users }

      it 'sends the notification' do
        VCR.use_cassette('publishes/users/valid_users') do
          response = publish_to_users

          expect(response).to be_ok
        end
      end
    end

    context 'when too many user ids are provided' do
      max_num_user_ids = Pusher::PushNotifications::UserId::MAX_NUM_USER_IDS
      int_array = (1..max_num_user_ids + 1).to_a.shuffle
      test_users = int_array.map do |num|
        "user-#{num}"
      end

      let(:users) { test_users }

      it 'raises an error' do
        VCR.use_cassette('publishes/users/valid_users') do
          expect { publish_to_users }.to raise_error(
            Pusher::PushNotifications::UseCases::
            PublishToUsers::UsersPublishError
          ).with_message("Number of user ids #{test_users.length} \
exceeds maximum of 1000.")
        end
      end
    end
  end
end
