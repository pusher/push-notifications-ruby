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

    context 'when there are two instances' do
      around do |ex|
        original_instance_id = described_class.instance_id
        original_secret_key = described_class.secret_key
        original_endpoint = described_class.endpoint

        ex.run

        described_class.configure do |c|
          c.instance_id = original_instance_id
          c.secret_key = original_secret_key
          c.endpoint = original_endpoint
        end
      end

      it 'uses the correct client' do
        client_a = Pusher::PushNotifications.configure do |config|
          config.instance_id = '123'
          config.secret_key = 'abc'
        end

        client_b = Pusher::PushNotifications.configure do |config|
          config.instance_id = '456'
          config.secret_key = 'def'
        end

        expect(Pusher::PushNotifications::UseCases::Publish)
          .to receive(:publish_to_interests)
          .with(client_a.send(:client), interests: interests, payload: payload)
          .and_return(nil)
          .once

        expect(Pusher::PushNotifications::UseCases::Publish)
          .to receive(:publish_to_interests)
          .with(client_b.send(:client), interests: interests, payload: payload)
          .and_return(nil)
          .once

        client_a.publish_to_interests(interests: interests, payload: payload)
        client_b.publish_to_interests(interests: interests, payload: payload)
      end
    end
  end
end
