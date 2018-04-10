# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications::UseCases::Publish do
  subject(:use_case) { described_class.new(interests: interests, payload: payload) }

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

  describe '#call' do
    subject(:send_notification) { use_case.call }

    context 'when payload is malformed' do
      let(:payload) do
        { invalid: 'paylaod' }
      end

      it 'does not send the notification' do
        VCR.use_cassette('publishes/invalid_payload') do
          response = send_notification

          expect(response).not_to be_ok
        end
      end
    end

    context 'when payload is correct' do
      it 'sends the notification' do
        VCR.use_cassette('publishes/valid_payload') do
          response = send_notification

          expect(response).to be_ok
        end
      end
    end

    context 'when interest name is invalid' do
      let(:interests) {['lovely-valid-interest', 'hey €€ ***']}

      it 'warns an interest name is invalid' do
        expect { send_notification }.to raise_error(
          Pusher::PushNotifications::UseCases::Publish::PublishError
        ).with_message(
          "Invalid interest name \nMax 164 characters and can only contain ASCII upper/lower-case letters, numbers or one of _-=@,.:"
        )
      end
    end

    context 'when no interests provided' do
      let(:interests) {[]}

      it 'warns to provide at least one interest' do
        expect { send_notification }.to raise_error(
          Pusher::PushNotifications::UseCases::Publish::PublishError
        ).with_message('Must provide at least one interest')
      end
    end

    context 'when 100 interests provided' do
      int_array = (1..100).to_a.shuffle
      test_interests = int_array.map do |num|
        "interest-#{num.to_s}"
      end

      let(:interests) { test_interests }

      it 'sends the notification' do
        VCR.use_cassette('publishes/valid_interests') do
          response = send_notification

          expect(response).to be_ok
        end
      end
    end
  end
end
