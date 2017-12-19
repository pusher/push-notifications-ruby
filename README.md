# Pusher::PushNotifications [![Build Status](https://travis-ci.org/lucasmedeirosleite/push-notifications-ruby.svg)](https://travis-ci.org/lucasmedeirosleite/push-notifications-ruby) [![Coverage Status](https://coveralls.io/repos/github/lucasmedeirosleite/push-notifications-ruby/badge.svg?branch=master)](https://coveralls.io/github/lucasmedeirosleite/push-notifications-ruby?branch=master)

Push notifications using the Pusher system.

## Getting started

The Push notifications system is still in BETA and it's free, but first you need to create an account on pusher (click [here](https://dash.pusher.com)).
With an account created you can create a new push notification instance (you will need to upload the apns certificates for apple and the server keys for Google's Firebase Cloud Messaging). Also you will need the `instance id` and `secret key` so the gem can be configured properly.

**NOTE**: The official Pusher [gem](https://github.com/pusher/pusher-http-ruby) currently does not support push notifications (probably because they moved it to another dashboard), you need to rely on the WEB API (that's why this gem was created).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'push_notifications', github: 'lucasmedeirosleite/push_notifications'
```

## Configuration

This configuration can be done anywhere you want, but if you are using rails the better place to put it is inside an initializer

```ruby
Pusher::PushNotifications.configure do |config|
  config.instance_id = ENV['PUSHER_INSTANCE_ID'] # or the value directly :)
  config.secret_key = ENV['PUSHER_SECRET_KEY']
end
```

Where `instance_id` and `secret_key` are the values of the instance you created in the push notifications dashboard

## Usage

After the configuration is done you can push notifications like this:

```ruby
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

Pusher::PushNotifications.notify(interests: ['my-interest'], payload: data)
```

The return of this call is a ruby struct containing the http status code (`status`) the response body (`content`) and an `ok?` attribute saying if the notification was successful or not.

**NOTE**: It's optional but you can insert a payload key at the same level of the `aps` and `notification` key with a custom value (A json for example), but keep in mind that you have the limitation of 10kb per message.

## Errors

The errors statuses can be:

HTTP Status | Reason
--- | --- 
401 | Incorrect secret key
400 | Payload too big (10Kb limit), Payload invalid, Payload in a wrong schema, instance_id missing
404 | Instance not found
500 | Internal server error

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucasmedeirosleite/push-notifications-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
