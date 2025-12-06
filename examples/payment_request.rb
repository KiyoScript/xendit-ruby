# frozen_string_literal: true

require_relative '../lib/xendit' # require 'xendit'

Xendit.api_key = 'your_api_key'

begin
  # Example 1: Create a Card Payment (PAY type)
  puts '\n=== Creating Card Payment Request ==='
  
  card_payment_params = {
    reference_id: "order_#{Time.now.to_i}",
    type: 'PAY',
    country: 'ID',
    currency: 'IDR',
    request_amount: 100_000,
    capture_method: 'AUTOMATIC',
    channel_code: 'CARDS',
    channel_properties: {
      mid_label: 'CTV_TEST',
      card_details: {
        cvn: '123',
        card_number: '4000000000001091',
        expiry_year: '2025',
        expiry_month: '12',
        cardholder_first_name: 'John',
        cardholder_last_name: 'Doe',
        cardholder_email: 'john.doe@example.com',
        cardholder_phone_number: '+628123456789'
      },
      skip_three_ds: false,
      failure_return_url: 'https://yoursite.com/failure',
      success_return_url: 'https://yoursite.com/success'
    },
    description: 'Payment for Order #123456',
    metadata: {
      order_id: '123456',
      customer_type: 'premium'
    }
  }

  created_payment = Xendit::PaymentRequest.create(card_payment_params)
  puts 'Created Payment Request:'
  puts JSON.pretty_generate(created_payment)

  payment_request_id = created_payment['payment_request_id']

  # Example 2: Get Payment Request by ID
  puts "\n=== Getting Payment Request ==="

  payment = Xendit::PaymentRequest.get(payment_request_id)
  puts 'Payment Request:'
  puts JSON.pretty_generate(payment)
  puts "Status: #{payment['status']}"

  # Example 3: Create with Custom Headers (XenPlatform)
  puts "\n=== Creating Payment with Custom Headers ==="

  custom_headers = {
    api_version: '2024-11-11',
    for_user_id: 'user-123', # Sub-account user ID
    with_split_rule: 'split-rule-456' # Split rule ID
  }

  platform_payment_params = {
    reference_id: "platform_order_#{Time.now.to_i}",
    type: 'PAY',
    country: 'ID',
    currency: 'IDR',
    request_amount: 250_000,
    capture_method: 'AUTOMATIC',
    channel_code: 'CARDS',
    channel_properties: {
      mid_label: 'CTV_TEST',
      card_details: {
        cvn: '123',
        card_number: '4000000000001091',
        expiry_year: '2025',
        expiry_month: '12'
      }
    },
    description: 'Platform payment with split'
  }

  platform_payment = Xendit::PaymentRequest.create(platform_payment_params, headers: custom_headers)
  puts 'Platform Payment Created:'
  puts JSON.pretty_generate(platform_payment)

  # Example 4: Create Manual Capture Payment
  puts '\n=== Creating Manual Capture Payment ==='

  manual_capture_params = {
    reference_id: "manual_#{Time.now.to_i}",
    type: 'PAY',
    country: 'ID',
    currency: 'IDR',
    request_amount: 150_000,
    capture_method: 'MANUAL', # Requires manual capture later
    channel_code: 'CARDS',
    channel_properties: {
      mid_label: 'CTV_TEST',
      card_details: {
        cvn: '123',
        card_number: '4000000000001091',
        expiry_year: '2025',
        expiry_month: '12'
      }
    },
    description: 'Manual capture payment'
  }

  manual_payment = Xendit::PaymentRequest.create(manual_capture_params)
  puts 'Manual Capture Payment Created:'
  puts JSON.pretty_generate(manual_payment)
  puts "Status: #{manual_payment['status']}"

  # Example 5: Create Reusable Payment Code
  puts '\n=== Creating Reusable Payment Code ==='

  reusable_params = {
    reference_id: "reusable_#{Time.now.to_i}",
    type: 'REUSABLE_PAYMENT_CODE',
    country: 'ID',
    currency: 'IDR',
    # NOTE: request_amount is not required for REUSABLE_PAYMENT_CODE
    channel_code: 'QRIS',
    channel_properties: {
      qr_string: 'sample_qr_string'
    },
    description: 'Reusable QR code for multiple payments'
  }

  reusable_payment = Xendit::PaymentRequest.create(reusable_params)
  puts 'Reusable Payment Code Created:'
  puts JSON.pretty_generate(reusable_payment)

  # Example 6: Create E-Wallet Payment (GCash)
  puts '\n=== Creating E-Wallet Payment (GCash) ==='

  ewallet_params = {
    reference_id: "gcash_#{Time.now.to_i}",
    type: 'PAY',
    country: 'PH',
    currency: 'PHP',
    request_amount: 1000,
    capture_method: 'AUTOMATIC',
    channel_code: 'GCASH',
    channel_properties: {
      success_redirect_url: 'https://yoursite.com/success',
      failure_redirect_url: 'https://yoursite.com/failure'
    },
    description: 'GCash payment'
  }

  ewallet_payment = Xendit::PaymentRequest.create(ewallet_params)
  puts 'E-Wallet Payment Created:'
  puts JSON.pretty_generate(ewallet_payment)

  # Get the status
  ewallet_status = Xendit::PaymentRequest.get(ewallet_payment['payment_request_id'])
  puts "E-Wallet Payment Status: #{ewallet_status['status']}"

  # Example 7: Create with Customer Details
  puts '\n=== Creating Payment with Customer Details ==='

  customer_payment_params = {
    reference_id: "customer_#{Time.now.to_i}",
    type: 'PAY',
    country: 'ID',
    currency: 'IDR',
    request_amount: 100_000,
    capture_method: 'AUTOMATIC',
    channel_code: 'CARDS',
    channel_properties: {
      mid_label: 'CTV_TEST',
      card_details: {
        cvn: '123',
        card_number: '4000000000001091',
        expiry_year: '2025',
        expiry_month: '12'
      }
    },
    customer: {
      type: 'INDIVIDUAL',
      reference_id: "customer_ref_#{Time.now.to_i}",
      email: 'customer@example.com',
      mobile_number: '+628123456789',
      individual_detail: {
        given_names: 'John',
        surname: 'Doe',
        nationality: 'ID',
        date_of_birth: '1990-01-01'
      }
    },
    description: 'Payment with customer details'
  }

  customer_payment = Xendit::PaymentRequest.create(customer_payment_params)
  puts 'Payment with Customer Details Created:'
  puts JSON.pretty_generate(customer_payment)

  # Example 8: PAY_AND_SAVE type (Save card for future use)
  puts '\n=== Creating PAY_AND_SAVE Payment ==='

  pay_and_save_params = {
    reference_id: "pay_save_#{Time.now.to_i}",
    type: 'PAY_AND_SAVE', # Will save payment token for reuse
    country: 'ID',
    currency: 'IDR',
    request_amount: 200_000,
    capture_method: 'AUTOMATIC',
    channel_code: 'CARDS',
    channel_properties: {
      mid_label: 'CTV_TEST',
      card_details: {
        cvn: '123',
        card_number: '4000000000001091',
        expiry_year: '2025',
        expiry_month: '12'
      }
    },
    description: 'Payment that saves card for future'
  }

  pay_and_save = Xendit::PaymentRequest.create(pay_and_save_params)
  puts 'PAY_AND_SAVE Payment Created:'
  puts JSON.pretty_generate(pay_and_save)
  puts "Payment Token ID: #{pay_and_save['payment_token_id']}" if pay_and_save['payment_token_id']

  # Example 9: Get Payment with Custom Headers
  puts '\n=== Getting Payment with Custom Headers ==='

  get_headers = {
    api_version: '2024-11-11',
    for_user_id: 'user-123'
  }

  payment_with_headers = Xendit::PaymentRequest.get(
    payment_request_id,
    headers: get_headers
  )
  puts 'Payment Retrieved with Custom Headers:'
  puts "Payment ID: #{payment_with_headers['payment_request_id']}"
  puts "Status: #{payment_with_headers['status']}"
  puts "Amount: #{payment_with_headers['request_amount']}"

  # Example 10: Checking Payment Status
  puts '\n=== Checking Payment Statuses ==='

  statuses = {
    'ACCEPTING_PAYMENTS' => 'Payment is waiting to be paid',
    'REQUIRES_ACTION' => 'Additional action needed from customer',
    'AUTHORIZED' => 'Payment authorized (for MANUAL capture)',
    'SUCCEEDED' => 'Payment successful',
    'FAILED' => 'Payment failed',
    'CANCELED' => 'Payment canceled',
    'EXPIRED' => 'Payment expired'
  }
  puts statuses

  current_payment = Xendit::PaymentRequest.get(payment_request_id)
  current_status = current_payment['status']

  puts "Current Payment Status: #{current_status}"
  puts "Status Description: #{statuses[current_status]}"
  puts "Failure Code: #{current_payment['failure_code']}" if current_payment['failure_code']
rescue Xendit::APIError => e
  puts '\nAPI Error occurred:'
  puts "Status: #{e.http_status}"
  puts "Error Code: #{e.error_code}"
  puts "Message: #{e.error_message}"
rescue ArgumentError => e
  puts '\nValidation Error:'
  puts e.message
end
