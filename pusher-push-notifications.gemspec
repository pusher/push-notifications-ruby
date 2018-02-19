
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pusher/push_notifications/version'

Gem::Specification.new do |spec|
  spec.name          = 'pusher-push-notifications'
  spec.version       = Pusher::PushNotifications::VERSION
  spec.authors       = ['Lucas Medeiros', 'Luka Bratos']
  spec.email         = ['lucastoc@gmail.com', 'luka@pusher.com']

  spec.summary       = 'PushNotifications pusher product'
  spec.description   = 'A gem to use the Pusher BETA product Push Notifications'
  spec.homepage      = 'https://github.com/lucasmedeirosleite/push-notifications-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'caze'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0.8.21'
  spec.add_development_dependency 'dotenv', '~> 2.2', '>= 2.2.1'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
  spec.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
end
