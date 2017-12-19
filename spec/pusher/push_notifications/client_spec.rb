# frozen_string_literal: true

RSpec.describe PushNotifications::Client do
  subject(:client) { described_class.new(config: config) }

  let(:config) { double(:config, instance_id: instance_id, secret_key: secret_key) }

  describe '#post' do
    subject(:send_post) { client.post(resource, body) }
    let(:resource) { 'publishes' }

    let(:instance_id) { ENV['PUSHER_INSTANCE_ID'] }
    let(:secret_key) { ENV['PUSHER_SECRET_KEY'] }
    let(:body) do
      {
        interests: [
          'hello'
        ],
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

    context 'when instance not found' do
      let(:instance_id) { 'abe1212381f60' }

      it 'returns 404' do
        VCR.use_cassette('publishes/invalid_instance_id') do
          response = send_post

          expect(response.status).to eq 404
        end
      end
    end

    context 'when secret key is incorrect' do
      let(:secret_key) { 'wrong-secret-key' }

      it 'returns 401' do
        VCR.use_cassette('publishes/invalid_secret_key') do
          response = send_post

          expect(response.status).to eq 401
        end
      end
    end

    context 'when payload is invalid' do
      let(:body) do
        {
          invalid: 'payload'
        }
      end

      it 'return 400' do
        VCR.use_cassette('publishes/invalid_payload') do
          response = send_post

          expect(response.status).to eq(400)
        end
      end
    end

    context 'when payload is valid' do
      it 'returns 200' do
        VCR.use_cassette('publishes/valid_payload') do
          response = send_post

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
