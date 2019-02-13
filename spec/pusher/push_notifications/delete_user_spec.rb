# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Pusher::PushNotifications::UseCases::DeleteUser do
  subject(:use_case) { described_class.new(user: user) }

  let(:user) { 'Elmo' }

  describe '#delete_user' do
    subject(:delete_user) { use_case.delete_user }

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
      let(:user) { 'a' * 165 }

      it 'user deletion request will fail' do
        expect { delete_user }.to raise_error(
          Pusher::PushNotifications::UseCases::DeleteUser::UserDeletionError
        ).with_message(
          'User id length too long (expected fewer than 165 characters'
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
end
