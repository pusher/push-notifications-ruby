# frozen_string_literal: true

require 'forwardable'
require 'json'
require 'rest-client'

module Pusher
  module PushNotifications
    class Client
      extend Forwardable

      Response = Struct.new(:status, :content, :ok?)

      def initialize(config: PushNotifications)
        @config = config
      end

      def post(resource, payload = {})
        url = build_publish_url(resource)
        body = payload.to_json

        RestClient::Request.execute(
          method: :post, url: url,
          payload: body, headers: headers
        ) do |response|
          status = response.code
          if json?(response.body)
            body = JSON.parse(response.body)
            Response.new(status, body, status == 200)
          else
            Response.new(status, nil, false)
          end
        end
      end

      def delete(user)
        url_encoded_user_id = CGI.escape(user)
        url = build_users_url(url_encoded_user_id)

        RestClient::Request.execute(
          method: :delete, url: url,
          headers: headers
        ) do |response|
          status = response.code
          case status
          when 200
            Response.new(status, nil, true)
          else
            Response.new(status, nil, false)
          end
        end
      end

      private

      attr_reader :config
      def_delegators :@config, :instance_id, :secret_key, :endpoint

      def build_publish_url(resource)
        "#{endpoint}/publish_api/v1/instances/#{instance_id}/#{resource}"
      end

      def build_users_url(user)
        "#{endpoint}/customer_api/v1/instances/#{instance_id}/users/#{user}"
      end

      def headers
        {
          content_type: 'application/json',
          accept: :json,
          Authorization: "Bearer #{secret_key}",
          'X-Pusher-Library':
          'pusher-push-notifications-ruby ' \
          "#{Pusher::PushNotifications::VERSION}"
        }
      end

      def json?(response)
        JSON.parse(response)
        true
      rescue JSON::ParserError
        false
      end
    end
  end
end
