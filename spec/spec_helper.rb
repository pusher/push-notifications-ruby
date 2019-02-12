# frozen_string_literal: true

if ENV['COVERAGE']
  require 'coveralls'
  Coveralls.wear!
end

require 'dotenv'
Dotenv.load

require 'bundler/setup'
require 'pry-byebug'
require 'pusher/push_notifications'
require 'vcr'
require 'webmock'

require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
