# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications do
  describe '.configure' do
    subject(:configuration) do
      described_class.configure do |config|
        config.instance_id = instance_id
        config.secret_key = secret_key
      end
    end

    let(:instance_id) { ENV['PUSHER_INSTANCE_ID'] }
    let(:secret_key) { ENV['PUSHER_SECRET_KEY'] }

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

    context 'when instance id and secret key are valid' do
      it 'has everything set up' do
        configuration

        expect(configuration.instance_id).not_to be_nil
        expect(configuration.instance_id).not_to be_empty

        expect(configuration.secret_key).not_to be_nil
        expect(configuration.secret_key).not_to be_empty
      end
    end
  end
end
