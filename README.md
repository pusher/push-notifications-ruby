# Pusher Beams Ruby Server SDK

[![Build Status](https://travis-ci.org/pusher/push-notifications-ruby.svg?branch=master)](https://travis-ci.org/pusher/push-notifications-ruby)
[![Coverage Status](https://coveralls.io/repos/github/pusher/push-notifications-ruby/badge.svg?branch=update-sdk)](https://coveralls.io/github/pusher/push-notifications-ruby?branch=update-sdk)

Pusher Beams using the Pusher system.

## Installation

```bash
gem install pusher-push-notifications
```

Or add this line to your application's Gemfile:

```ruby
gem 'pusher-push-notifications'
```

## Configuration

This configuration can be done anywhere you want, but if you are using rails the better place to put it is inside an initializer

```ruby
require 'pusher/push_notifications'

Pusher::PushNotifications.configure do |config|
  config.instance_id = ENV['PUSHER_INSTANCE_ID'] # or the value directly
  config.secret_key = ENV['PUSHER_SECRET_KEY']
end
```

Where `instance_id` and `secret_key` are the values of the instance you created in the Pusher Beams dashboard.

If multiple clients are needed, store the reference that is returned from the `configure` method.

## Usage

After the configuration is done you can push notifications like this:

```ruby
require 'pusher/push_notifications'

data = {
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

# Publish the given 'data' to the specified interests.
Pusher::PushNotifications.publish_to_interests(interests: ['hello'], payload: data)

# Publish the given 'data' to the specified users.
Pusher::PushNotifications.publish_to_users(users: ['jonathan', 'jordan', 'luis', 'luka', 'mina'], payload: data)

# Authenticate User
Pusher::PushNotifications.generate_token(user: 'Elmo')

# Delete User
Pusher::PushNotifications.delete_user(user: 'Elmo')
```

The return of this call is a ruby struct containing the http status code (`status`) the response body (`content`) and an `ok?` attribute saying if the notification was successful or not.

**NOTE**: It's optional but you can insert a `data` key at the same level of the `aps` and `notification` keys with a custom value (A json for example), but keep in mind that you have the limitation of 10kb per message.

## Errors

All available error responses can be be found [here](https://docs.pusher.com/beams/reference/publish-api#error-responses).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

- Found a bug? Please open an [issue](https://github.com/pusher/push-notifications-ruby/issues).
- Have a feature request. Please open an [issue](https://github.com/pusher/push-notifications-ruby/issues).
- If you want to contribute, please submit a [pull request](https://github.com/pusher/push-notifications-ruby/pulls) (preferrably with some tests).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
