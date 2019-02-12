# frozen_string_literal: true

module Pusher
  module PushNotifications
    class UserId
      def max_user_id_length
        164
      end

      def max_num_user_ids
        1000
      end
    end
  end
end
