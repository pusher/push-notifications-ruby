# frozen_string_literal: true

require 'caze'

require 'push_notifications/client'
require 'push_notifications/use_cases/notify'
require 'push_notifications/version'

module PushNotifications
  include Caze

  class PushError < RuntimeError; end

  has_use_case :notify, UseCases::Notify

  class << self
    attr_reader :instance_id, :secret_key

    def configure
      yield(self)
      self
    end

    def instance_id=(instance_id)
      raise PushError, 'Invalid instance id' if instance_id.nil? || instance_id.delete(' ').empty?
      @instance_id = instance_id
    end

    def secret_key=(secret_key)
      raise PushError, 'Invalid secret key' if secret_key.nil? || secret_key.delete(' ').empty?
      @secret_key = secret_key
    end
  end
end
