Conduit [![Code Climate](https://codeclimate.com/repos/51c2044589af7e2b8b00e93d/badges/5ca50d283c35ec593fb6/gpa.png)](https://codeclimate.com/repos/51c2044589af7e2b8b00e93d/feed)
===========================

Conduit is designed to act as an asynchronous driver driven communication engine. Nothing inside conduit will dictate what you communicate with,
or how you communicate with it, but rather only gives a basic foundation for communicating with external services.

## Installation
Add conduit to your `Gemfile`.

```ruby
gem 'conduit'
```

## Usage

Conduit uses models to store communication parameters until such a time that it can be sent.
To create a request, just add a record for the request, providing the `driver name`, the `action name`,
and an `options hash` for that action.

```ruby
Conduit::Request.create!(
  driver: :fusion,
  action: :purchase,
  options: {
    clec_id:  213,
    username: 'MyUser',
    token:    'MyToken',
    mdn:      '1234567890',
    plan_id:  339
});
```

The above will create a `Conduit::Request` record, and trigger the communication in the background. It will
store the response as a `Conduit::Response` record.