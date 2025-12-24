# frozen_string_literal: true

require_relative '../lib/xendit' # require 'xendit'

Xendit.api_key = 'your_api_key'

begin
  # Example 1: Create a Bank Payout (BCA Indonesia)
  puts '\n=== Creating Bank Payout (BCA) ==='

  bank_payout_params = {
    reference_id: "payout_#{Time.now.to_i}",
    channel_code: 'ID_BCA',
    channel_properties: {
      account_number: '000000000099',
      account_holder_name: 'Michael Chen'
    },
    amount: 100_000,
    description: 'December salary payout',
    currency: 'IDR'
  }

  # Using reference_id as idempotency key
  created_payout = Xendit::Payout.create(
    bank_payout_params,
    headers: {idempotency_key: bank_payout_params[:reference_id]}
  )
  puts 'Created Payout:'
  puts JSON.pretty_generate(created_payout)
  puts "Payout ID: #{created_payout['id']}"
  puts "Status: #{created_payout['status']}"

  payout_id = created_payout['id']

  # Example 2: Get Payout by ID
  puts "\n=== Getting Payout by ID ==="

  payout = Xendit::Payout.get(payout_id)
  puts 'Payout Details:'
  puts JSON.pretty_generate(payout)
  puts "Status: #{payout['status']}"
  puts "Amount: #{payout['amount']}"
  puts "Estimated Arrival: #{payout['estimated_arrival_time']}"

  # Example 3: Get Payout by Reference ID
  puts "\n=== Getting Payout by Reference ID ==="

  payouts_by_ref = Xendit::Payout.get_by_reference_id(bank_payout_params[:reference_id])
  puts 'Payouts with Reference ID:'
  puts JSON.pretty_generate(payouts_by_ref)

  # Example 4: Create E-Wallet Payout (OVO)
  puts '\n=== Creating E-Wallet Payout (OVO) ==='

  ewallet_payout_params = {
    reference_id: "ovo_payout_#{Time.now.to_i}",
    channel_code: 'ID_OVO',
    channel_properties: {
      account_number: '081234567890',
      account_holder_name: 'Sarah Johnson'
    },
    amount: 50_000,
    description: 'Cashback payment',
    currency: 'IDR'
  }

  ewallet_payout = Xendit::Payout.create(
    ewallet_payout_params,
    headers: {idempotency_key: ewallet_payout_params[:reference_id]}
  )
  puts 'E-Wallet Payout Created:'
  puts JSON.pretty_generate(ewallet_payout)

  # Example 5: Create Payout with Email Notifications
  puts '\n=== Creating Payout with Email Notifications ==='

  payout_with_email_params = {
    reference_id: "email_payout_#{Time.now.to_i}",
    channel_code: 'ID_MANDIRI',
    channel_properties: {
      account_number: '1234567890',
      account_holder_name: 'John Doe'
    },
    amount: 250_000,
    description: 'Commission payment',
    currency: 'IDR',
    receipt_notification: {
      email_to: ['recipient@example.com'],
      email_cc: ['manager@example.com'],
      email_bcc: ['accounting@example.com']
    }
  }

  payout_with_email = Xendit::Payout.create(
    payout_with_email_params,
    headers: {idempotency_key: payout_with_email_params[:reference_id]}
  )
  puts 'Payout with Email Notifications Created:'
  puts JSON.pretty_generate(payout_with_email)

  # Example 6: Create Payout with Metadata
  puts '\n=== Creating Payout with Metadata ==='

  payout_with_metadata_params = {
    reference_id: "metadata_payout_#{Time.now.to_i}",
    channel_code: 'ID_BNI',
    channel_properties: {
      account_number: '9876543210',
      account_holder_name: 'Jane Smith'
    },
    amount: 150_000,
    description: 'Vendor payment',
    currency: 'IDR',
    metadata: {
      order_id: '123456',
      vendor_id: 'V789',
      payment_type: 'vendor_payment',
      department: 'procurement'
    }
  }

  payout_with_metadata = Xendit::Payout.create(
    payout_with_metadata_params,
    headers: {idempotency_key: payout_with_metadata_params[:reference_id]}
  )
  puts 'Payout with Metadata Created:'
  puts JSON.pretty_generate(payout_with_metadata)
  puts "Metadata: #{payout_with_metadata['metadata']}"

  # Example 7: Create PHP Payout (Philippines)
  puts '\n=== Creating PHP Payout (Philippines) ==='

  php_payout_params = {
    reference_id: "php_payout_#{Time.now.to_i}",
    channel_code: 'PH_BDO',
    channel_properties: {
      account_number: '1234567890',
      account_holder_name: 'Maria Santos'
    },
    amount: 5000.50, # PHP can have 2 decimal places
    description: 'Freelancer payment',
    currency: 'PHP'
  }

  php_payout = Xendit::Payout.create(
    php_payout_params,
    headers: {idempotency_key: php_payout_params[:reference_id]}
  )
  puts 'PHP Payout Created:'
  puts JSON.pretty_generate(php_payout)

  # Example 8: Create MYR Payout with DuitNow (Malaysia)
  puts '\n=== Creating MYR Payout with DuitNow ==='

  duitnow_payout_params = {
    reference_id: "duitnow_#{Time.now.to_i}",
    channel_code: 'MY_DUITNOW',
    channel_properties: {
      account_number: '60123456789', # Mobile number
      account_holder_name: 'Ahmad Abdullah',
      account_type: 'MOBILE_NO' # Using mobile number as proxy
    },
    amount: 100.50, # MYR can have 2 decimal places
    description: 'Refund payment',
    currency: 'MYR'
  }

  duitnow_payout = Xendit::Payout.create(
    duitnow_payout_params,
    headers: {idempotency_key: duitnow_payout_params[:reference_id]}
  )
  puts 'DuitNow Payout Created:'
  puts JSON.pretty_generate(duitnow_payout)

  # Example 9: Create THB Payout (Thailand)
  puts '\n=== Creating THB Payout (Thailand) ==='

  thb_payout_params = {
    reference_id: "thb_payout_#{Time.now.to_i}",
    channel_code: 'TH_BANGKOK_BANK',
    channel_properties: {
      account_number: '1234567890',
      account_holder_name: 'Somchai Patel',
      account_type: 'BANK_ACCOUNT'
    },
    amount: 1500.75, # THB can have 2 decimal places
    description: 'Service payment',
    currency: 'THB'
  }

  thb_payout = Xendit::Payout.create(
    thb_payout_params,
    headers: {idempotency_key: thb_payout_params[:reference_id]}
  )
  puts 'THB Payout Created:'
  puts JSON.pretty_generate(thb_payout)

  # Example 10: Create Payout with XenPlatform (Sub-account)
  puts '\n=== Creating Payout with XenPlatform ==='

  platform_payout_params = {
    reference_id: "platform_payout_#{Time.now.to_i}",
    channel_code: 'ID_BCA',
    channel_properties: {
      account_number: '111222333444',
      account_holder_name: 'Platform User'
    },
    amount: 500_000,
    description: 'Sub-account payout',
    currency: 'IDR'
  }

  platform_headers = {
    idempotency_key: platform_payout_params[:reference_id],
    for_user_id: 'sub-account-user-123' # XenPlatform sub-account ID
  }

  platform_payout = Xendit::Payout.create(
    platform_payout_params,
    headers: platform_headers
  )
  puts 'Platform Payout Created:'
  puts JSON.pretty_generate(platform_payout)

  # Example 11: Checking Payout Status
  puts '\n=== Checking Payout Status ==='

  statuses = {
    'ACCEPTED' => 'Payout accepted, waiting to be processed',
    'REQUESTED' => 'Payout sent to the channel for processing',
    'FAILED' => 'Payout failed',
    'SUCCEEDED' => 'Payout successful',
    'CANCELLED' => 'Payout cancelled',
    'REVERSED' => 'Payout reversed by channel'
  }

  puts 'Available Payout Statuses:'
  statuses.each { |status, description| puts "  #{status}: #{description}" }

  current_payout = Xendit::Payout.get(payout_id)
  current_status = current_payout['status']

  puts "\nCurrent Payout Status: #{current_status}"
  puts "Status Description: #{statuses[current_status]}"

  if current_payout['failure_code']
    puts "Failure Code: #{current_payout['failure_code']}"

    failure_codes = {
      'INSUFFICIENT_BALANCE' => 'Client has insufficient balance',
      'INVALID_DESTINATION' => 'Recipient account does not exist/is invalid',
      'REJECTED_BY_CHANNEL' => 'Failed due to channel error',
      'TEMPORARY_TRANSFER_ERROR' => 'Channel networks temporary error',
      'TRANSFER_ERROR' => 'Fatal error while processing',
      'UNKNOWN_BANK_NETWORK_ERROR' => 'Undocumented bank error',
      'DESTINATION_MAXIMUM_LIMIT' => 'Amount exceeds recipient limit'
    }

    puts "Failure Reason: #{failure_codes[current_payout['failure_code']]}"
  end

  # Example 12: Multiple Payouts with Different Idempotency Keys
  puts '\n=== Creating Multiple Payouts ==='

  3.times do |i|
    multi_payout_params = {
      reference_id: "batch_payout_#{Time.now.to_i}_#{i}",
      channel_code: 'ID_BCA',
      channel_properties: {
        account_number: "00000000#{i.to_s.rjust(4, '0')}",
        account_holder_name: "Employee #{i + 1}"
      },
      amount: 75_000 + (i * 25_000),
      description: "Batch payout #{i + 1}",
      currency: 'IDR'
    }

    batch_payout = Xendit::Payout.create(
      multi_payout_params,
      headers: {idempotency_key: multi_payout_params[:reference_id]}
    )

    puts "\nBatch Payout #{i + 1} Created:"
    puts "  ID: #{batch_payout['id']}"
    puts "  Amount: #{batch_payout['amount']}"
    puts "  Status: #{batch_payout['status']}"
  end

  # Example 13: Get Payout with XenPlatform Headers
  puts '\n=== Getting Payout with XenPlatform Headers ==='

  get_platform_headers = {
    for_user_id: 'sub-account-user-123'
  }

  platform_payout_details = Xendit::Payout.get(
    platform_payout['id'],
    headers: get_platform_headers
  )

  puts 'Platform Payout Details:'
  puts "  Payout ID: #{platform_payout_details['id']}"
  puts "  Business ID: #{platform_payout_details['business_id']}"
  puts "  Amount: #{platform_payout_details['amount']}"
  puts "  Status: #{platform_payout_details['status']}"
rescue Xendit::APIError => e
  puts '\nAPI Error occurred:'
  puts "Status: #{e.http_status}"
  puts "Error Code: #{e.error_code}"
  puts "Message: #{e.error_message}"
rescue ArgumentError => e
  puts '\nValidation Error:'
  puts e.message
end
