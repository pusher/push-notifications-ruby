# frozen_string_literal: true

require 'forwardable'
require 'json'
require 'rest-client'

module Pusher
  module PushNotifications
    class Client
      extend Forwardable

      BASE_URL = 'pushnotifications.pusher.com/publish_api/v1/instances'

      Response = Struct.new(:status, :content, :ok?)

      def initialize(config: Pusher::PushNotifications)
        @config = config
      end

      def post(resource, payload = {})
        url = build_url(resource)
        body = payload.to_json
        RestClient::Request.execute(
          method: :post, url: url,
          payload: body, headers: headers
        ) do |response|
          status = response.code
          body = JSON.parse(response.body)
          Response.new(status, body, status == 200 ? true : false)
        end
      end

      private

      attr_reader :config
      def_delegators :@config, :instance_id, :secret_key

      def build_url(resource)
        "https://#{instance_id}.#{BASE_URL}/#{instance_id}/#{resource}"
      end

      def headers
        {
          content_type: 'application/json',
          accept: :json,
          Authorization: "Bearer #{secret_key}"
        }
      end
    end
  end
end
