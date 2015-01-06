# Paysera

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paysera'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paysera

## Usage

You can set default config like so:

```ruby
Paysera.config do |config|
  config.project_id = 56571
  config.sign_password = '36947d6dcbccc03ad591deab138dbb0c'
end
```

If you are using Ruby on Rails add it to `config/initializers/paysera.rb`. However it do not necessarily has to be rails,
you can add this into any Ruby app.

### Request

To make a request you only need to execute this:

```ruby
# Minimum requirements for request_params
request_params_example = {
  orderid: 1,
  accepturl: 'http://0.0.0.0:3000?accept',
  cancelurl: 'http://0.0.0.0:3000?cancel',
  callbackurl: 'http://0.0.0.0:3000?callback'
}
Paysera::Request.build_request(request_params_example, [sign_password])
```

It will generate payment link to paysera(`https://mokejimai.lt/pay/?data=...&sign=...`). So you can:

```ruby
redirect_to Paysera::Request.build_request(...)
```

You can specify all parameters from: https://developers.paysera.com/en/payments/current#request-parameters

If required parameter not found or it is invalid it will raise `Paysera::Error::Request` error with specific error message.

If you specify `projectid` or `sign_password`  it will overwrite initializer.

### Response

```ruby
# params should include valid data, ss1 and ss2
response = Paysera::Response.new(params, [project_id], [sign_password])
```

To check if response is sms/mikro
```ruby
response.sms?
```

To check if response is bank/makro:
```ruby
response.bank?
```

To get response data:
```ruby
response.get_data
```
It will return Hash of data: [SMS specification](https://developers.paysera.com/en/sms-keywords/current#detailed-specification) and [Bank specification(see "Encoded parameters")](https://developers.paysera.com/en/payments/1.6#integration-via-specification)


If you specify `project_id` or `sign_password` it will overwrite initializer.

## Contributing

1. Fork it ( https://github.com/TomasAchmedovas/paysera/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License: see `[LICENSE](https://github.com/TomasAchmedovas/paysera/blob/master/LICENSE)` file