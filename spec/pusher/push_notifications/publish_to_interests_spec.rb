# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications, '.publish_to_interests' do
  def publish_to_interests
    described_class.publish_to_interests(interests: interests, payload: payload)
  end

  let(:interests) { ['hello'] }
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

  describe '#publish_to_interests' do
    context 'when payload is malformed' do
      let(:payload) do
        { invalid: 'payload' }
      end

      it 'does not send the notification' do
        VCR.use_cassette('publishes/interests/invalid_payload') do
          response = publish_to_interests

          expect(response).not_to be_ok
        end
      end
    end

    context 'when payload is correct' do
      it 'sends the notification' do
        VCR.use_cassette('publishes/interests/valid_payload') do
          response = publish_to_interests

          expect(response).to be_ok
        end
      end
    end

    context 'when interest name is invalid' do
      let(:interests) { ['lovely-valid-interest', 'hey €€ ***'] }
      max_user_id_length = Pusher::PushNotifications::UserId::MAX_USER_ID_LENGTH

      it 'warns an interest name is invalid' do
        expect { publish_to_interests }.to raise_error(
          Pusher::PushNotifications::UseCases::Publish::PublishError
        ).with_message("Invalid interest name \nMax #{max_user_id_length} \
characters and can only contain ASCII upper/lower-case letters, numbers \
or one of _-=@,.:")
      end
    end

    context 'when no interests provided' do
      let(:interests) { [] }

      it 'warns to provide at least one interest' do
        expect { publish_to_interests }.to raise_error(
          Pusher::PushNotifications::UseCases::Publish::PublishError
        ).with_message('Must provide at least one interest')
      end
    end

    context 'when 100 interests provided' do
      int_array = (1..100).to_a.shuffle
      test_interests = int_array.map do |num|
        "interest-#{num}"
      end

      let(:interests) { test_interests }

      it 'sends the notification' do
        VCR.use_cassette('publishes/interests/valid_interests') do
          response = publish_to_interests

          expect(response).to be_ok
        end
      end
    end

    context 'when too many interests are provided' do
      int_array = (1..101).to_a.shuffle
      test_interests = int_array.map do |num|
        "interest-#{num}"
      end

      let(:interests) { test_interests }

      it 'raises an error' do
        VCR.use_cassette('publishes/interests/valid_interests') do
          expect { publish_to_interests }.to raise_error(
            Pusher::PushNotifications::UseCases::Publish::PublishError
          ).with_message("Number of interests #{interests.length} \
exceeds maximum of 100")
        end
      end
    end
  end
end
