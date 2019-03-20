# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pusher/push_notifications/version'

Gem::Specification.new do |spec|
  spec.name          = 'pusher-push-notifications'
  spec.version       = Pusher::PushNotifications::VERSION
  spec.authors       = ['Lucas Medeiros', 'Pusher']
  spec.email         = ['lucastoc@gmail.com', 'support@pusher.com']

  spec.summary       = 'Pusher Push Notifications Ruby server SDK'
  spec.homepage      = 'https://github.com/pusher/push-notifications-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'caze', '~> 0'
  spec.add_dependency 'jwt', '~> 2.1', '>= 2.1.0'
  spec.add_dependency 'rest-client', '~> 2.0', '>= 2.0.2'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'codecov', '~> 0'
  spec.add_development_dependency 'coveralls', '~> 0.8.21'
  spec.add_development_dependency 'dotenv', '~> 2.2', '>= 2.2.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.6', '>= 3.6.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rb-readline', '~> 0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '>= 0.49.0'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
  spec.add_development_dependency 'webmock', '~> 3.0', '>= 3.0.1'
end
