# frozen_string_literal: true

if ENV['COVERAGE']
  require 'coveralls'
  Coveralls.wear!
end

require 'dotenv'
Dotenv.load

require 'bundler/setup'
require 'pry-byebug'
require 'push_notifications'
require 'vcr'
require 'webmock'

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
