# Paysera

*"Paysera is an advanced, effective, proven and safe electronic money system with an unlimited electronic money licence No. 1 issued by the Bank of Lithuania. It offers a free settlement account which allows for a quick, safe and low-cost (often – free of charge) payment for goods and services.
 Paysera account is a true electronic wallet, which can not be lost; you will always find the amount of money that you have deposited in your account. In most cases, this type of account is better than bank account, because it is subject to higher security requirements, administrators of Paysera system can not lend or invest money held on the owner’s account.
 Paysera.com services are constantly expanded and improved by the top-level specialists in accordance with the latest payment innovations."* — [Paysera](https://www.paysera.com/index.html)

This gem provides easy access to Paysera payment API.

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
  config.projectid = 56571
  config.sign_password = '36947d6dcbccc03ad591deab138dbb0c'
end
```

If you are using *Ruby on Rails* add it to `config/initializers/paysera.rb`. However it do not necessarily has to be rails,
you can add this into any Ruby app.

#### Request

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

It will generate payment link to paysera - `https://mokejimai.lt/pay/?data=...&sign=...`.
So you can do this if you are using *Rails*:


```ruby
redirect_to Paysera::Request.build_request(...)
```

You can use all parameters from: https://developers.paysera.com/en/payments/current#request-parameters

If required parameter not found or it is invalid it will raise `Paysera::Error::Request` error with specific error message.

If you specify `projectid` or `sign_password`  it will overwrite initializer.

#### Response

```ruby
# params should include valid data, ss1 and ss2
response = Paysera::Response.new(params, [projectid], [sign_password])
```

If `ss1` or `ss2` will fail to validate it will raise `Paysera::Error::Response` error with specific error message.

To check if response is sms/mikro

```ruby
if response.sms?
  ...
end
```

To check if response is bank/makro:

```ruby
if response.bank?
  ...
end
```

To get response data (keys are symbols):

```ruby
response.get_data

puts response.get_data[:sms] # => keyword1 text
```

It will return Hash of data: [SMS specification](https://developers.paysera.com/en/sms-keywords/current#detailed-specification) and [Bank specification(see "Encoded parameters")](https://developers.paysera.com/en/payments/1.6#integration-via-specification)


If you specify `projectid` or `sign_password` it will overwrite initializer.

Also you propably want to skip CSRF verify in callback action, here's how:
```ruby
skip_before_filter :verify_authenticity_token, :only => [:receive_callback] # :receive_callback - your callback action
```

## Contributing

1. Fork it ( https://github.com/TomasAchmedovas/paysera/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

MIT License: see [LICENSE](https://github.com/TomasAchmedovas/paysera/blob/master/LICENSE) file
