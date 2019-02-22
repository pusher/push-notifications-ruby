# frozen_string_literal: true

RSpec.describe Pusher::PushNotifications::Client do
  subject(:client) { described_class.new(config: config) }

  let(:config) do
    double(:config, instance_id: instance_id, secret_key: secret_key)
  end

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
  end
  describe '#post_interests' do
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

    context 'when publish to interests payload is invalid' do
      let(:body) do
        {
          invalid: 'payload'
        }
      end

      it 'return 422' do
        VCR.use_cassette('publishes/interests/invalid_payload') do
          response = send_post

          expect(response.status).to eq(422)
        end
      end
    end

    context 'when publish to interests payload is valid' do
      it 'returns 200' do
        VCR.use_cassette('publishes/interests/valid_payload') do
          response = send_post

          expect(response.status).to eq(200)
        end
      end
    end
  end
  describe '#post_users' do
    subject(:send_post) { client.post(resource, body) }
    let(:resource) { 'publishes/users' }

    let(:instance_id) { ENV['PUSHER_INSTANCE_ID'] }
    let(:secret_key) { ENV['PUSHER_SECRET_KEY'] }
    let(:body) do
      {
        users: %w[
          jonathan jordan luis luka mina
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

    context 'when publish to users payload is invalid' do
      let(:body) do
        {
          invalid: 'payload'
        }
      end

      it 'return 422' do
        VCR.use_cassette('publishes/users/invalid_payload') do
          response = send_post

          expect(response.status).to eq(422)
        end
      end
    end

    context 'when publish to users payload is valid' do
      it 'returns 200' do
        VCR.use_cassette('publishes/users/valid_payload') do
          response = send_post

          expect(response.status).to eq(200)
        end
      end
    end
  end
  describe '#delete_user' do
    let(:user) { "Stop!' said Fred user" }
    let(:instance_id) { ENV['PUSHER_INSTANCE_ID'] }
    let(:secret_key) { ENV['PUSHER_SECRET_KEY'] }

    subject(:delete_user) { client.delete(user) }

    context 'when user id is empty' do
      let(:user) { '' }

      it 'return 404' do
        VCR.use_cassette('delete/user/id_empty') do
          response = delete_user

          expect(response.status).to eq(404)
        end
      end
    end

    context 'when user id is too long' do
      max_user_id_length = Pusher::PushNotifications::UserId::MAX_USER_ID_LENGTH
      let(:user) { 'a' * (max_user_id_length + 1) }

      it 'return 400' do
        VCR.use_cassette('delete/user/id_too_long') do
          response = delete_user

          expect(response.status).to eq(400)
        end
      end
    end

    context 'when user id is valid' do
      it 'returns 200' do
        VCR.use_cassette('delete/user') do
          response = delete_user

          expect(response.status).to eq(200)
        end
      end
    end
  end
end
