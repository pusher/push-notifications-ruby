# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications do
  describe '.configure' do
    subject(:configuration) do
      described_class.configure do |config|
        config.instance_id = instance_id
        config.secret_key = secret_key
        config.endpoint = endpoint
      end
    end

    let(:instance_id) { ENV['PUSHER_INSTANCE_ID'] }
    let(:secret_key) { ENV['PUSHER_SECRET_KEY'] }
    let(:endpoint) { nil }

    context 'when instance id is not valid' do
      context 'when instance_id is nil' do
        let(:instance_id) { nil }

        it 'warns instance_id is invalid' do
          expect { configuration }.to raise_error(
            Pusher::PushNotifications::PushError
          ).with_message('Invalid instance id')
        end
      end

      context 'when instance_id is empty' do
        let(:instance_id) { ' ' }

        it 'warns instance_id is invalid' do
          expect { configuration }.to raise_error(
            Pusher::PushNotifications::PushError
          ).with_message('Invalid instance id')
        end
      end
    end

    context 'when secret key is not valid' do
      context 'when secret_key is nil' do
        let(:secret_key) { nil }

        it 'warns secret_key is invalid' do
          expect { configuration }.to raise_error(
            Pusher::PushNotifications::PushError
          ).with_message('Invalid secret key')
        end
      end

      context 'when secret_key is empty' do
        let(:secret_key) { ' ' }

        it 'warns secret_key is invalid' do
          expect { configuration }.to raise_error(
            Pusher::PushNotifications::PushError
          ).with_message('Invalid secret key')
        end
      end
    end

    context 'when endpoint is not valid' do
      context 'when endpoint is empty' do
        let(:endpoint) { ' ' }

        it 'warns endpoint is invalid' do
          expect { configuration }.to raise_error(
            Pusher::PushNotifications::PushError
          ).with_message('Invalid endpoint override')
        end
      end
    end

    context 'when endpoint is valid' do
      let(:endpoint) { 'https://testcluster.pusher.com' }

      it 'overrides the default endpoint' do
        configuration

        expect(configuration.endpoint).to eq('https://testcluster.pusher.com')
      end
    end

    context 'when instance id and secret key are valid' do
      it 'has everything set up' do
        configuration

        expect(configuration.instance_id).not_to be_nil
        expect(configuration.instance_id).not_to be_empty

        expect(configuration.secret_key).not_to be_nil
        expect(configuration.secret_key).not_to be_empty

        expect(configuration.endpoint).not_to be_nil
        expect(configuration.endpoint).not_to be_empty
        expect(configuration.endpoint).to eq(
          "https://#{configuration.instance_id}.pushnotifications.pusher.com"
        )
      end
    end

    context 'when multiple instances are needed' do
      it 'returns unique clients' do
        client1 = described_class.configure do |config|
          config.instance_id = 'acd22e93-d8d6-43ba-9023-20ec05b1d08e'
          config.secret_key = '123'
          config.endpoint = 'https://testcluster.pusher.com'
        end
        client2 = described_class.configure do |config|
          config.instance_id = instance_id
          config.secret_key = secret_key
          config.endpoint = endpoint
        end

        expect(client1).not_to eq(client2)
        expect(client1.instance_id).not_to eq(client2.instance_id)
        expect(client1.secret_key).not_to eq(client2.secret_key)
        expect(client1.endpoint).not_to eq(client2.endpoint)
      end
    end
  end
end
