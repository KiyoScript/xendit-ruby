# Xendit API Ruby Library

This library is the abstraction of Xendit API for access from applications written with Ruby/Rails.

<!-- toc -->

- [API Documentation](#api-documentation)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  * [Invoice Service](#invoice-service)

<!-- tocstop -->

## API Documentation

Please check [Xendit API Reference](https://xendit.github.io/apireference/).

## Requirements
- Ruby 2.5+.

## Installation
Add this line to your application’s Gemfile:
```bash
gem 'xendit'
```
And then execute:
```bash
$ bundle
```
Access the library in Ruby/Rails project:
```ruby
require 'xendit'
```

## Usage

First, start by setting up with your account's **secret key** obtained from your [Xendit Dashboard](https://dashboard.xendit.co/settings/developers#api-keys).
Once done, you are ready to use all services provided in this library.

```ruby
require 'xendit'

# Provide api key
Xendit.api_key = 'xnd_...'
```

### Invoice Service

Refer to [Xendit API Reference](https://xendit.github.io/apireference/#invoices) for more info about methods' parameters

Create an invoice
```ruby
# setup invoice details
invoice_params = {
    external_id: 'demo_147580196270',
    payer_email: 'sample_email@xendit.co',
    description: 'Trip to Bali',
    amount: 10_000_000
}
# create an invoice
created_invoice = Xendit::Invoice.create invoice_params
```

Get an invoice
```ruby
# get an invoice
invoice = Xendit::Invoice.get '5efda8a20425db620ec35f43'
```

Get all invoices
```ruby
# setup filters
filter_params = {
    limit: 3
}
# get invoices
invoices = Xendit::Invoice.get_all filter_params
```

Expire an invoice
```ruby
# expire an invoice
expired_invoice = Xendit::Invoice.expire '5efda8a20425db620ec35f43'
```
Payment Request Service
> New in version 1.1.0

The `PaymentRequest` resource provides a unified way to create and retrieve card payments, e-wallets, QRIS, reusable codes, manual capture, and advanced flows such as PAY.

Create a Card Payment
```ruby
params = {
  reference_id: "order_#{Time.now.to_i}",
  type: 'PAY',
  country: 'ID',
  currency: 'IDR',
  request_amount: 100_000,
  capture_method: 'AUTOMATIC',
  channel_code: 'CARDS',
  channel_properties: {
    mid_label: 'TEST_MID',
    card_details: {
      cvn: '123',
      card_number: '4000000000001091',
      expiry_year: '2025',
      expiry_month: '12'
    }
  },
  description: 'Card payment example'
}

payment = Xendit::PaymentRequest.create(params)

```
Get a Payment Request
```ruby
payment = Xendit::PaymentRequest.get('payment_request_id')
```
Create Payment with Custom Headers (XenPlatform)
```ruby
headers = {
  api_version: '2024-11-11',
  for_user_id: 'sub-account-id', #(optional)
  with_split_rule: 'split-rule-id' #(optional)
}

payment = Xendit::PaymentRequest.create(params, headers: headers)
```

Manual Capture Example
```ruby
params[:capture_method] = 'MANUAL'

manual_payment = Xendit::PaymentRequest.create(params)
```
E-Wallet Example (GCash)
```ruby
ewallet_params = {
  reference_id: "gcash_#{Time.now.to_i}",
  type: 'PAY',
  country: 'PH',
  currency: 'PHP',
  request_amount: 1000,
  channel_code: 'GCASH',
  channel_properties: {
    success_redirect_url: 'https://yourapp.com/success',
    failure_redirect_url: 'https://yourapp.com/failure'
  }
}

payment = Xendit::PaymentRequest.create(ewallet_params)
```

Error Handling
```ruby
begin
  Xendit::PaymentRequest.create(params)
rescue Xendit::APIError => e
  puts "Status: #{e.http_status}"
  puts "Code: #{e.error_code}"
  puts "Message: #{e.error_message}"
end
```