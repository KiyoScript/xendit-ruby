# frozen_string_literal: true

require 'faraday'
require 'json'

require_relative '../api_operations'
require_relative '../response'

module Xendit
  class PaymentRequest
    class << self
      def get(payment_request_id, headers: {})
        # validation
        raise ArgumentError, 'payment_request_id is required and should be a string' \
            if payment_request_id.nil? || !payment_request_id.is_a?(String)
        raise ArgumentError, 'payment_request_id must be 39 characters' \
            if payment_request_id.length != 39

        request_headers = build_headers(headers)

        resp = Xendit::APIOperations.get("v3/payment_requests/#{payment_request_id}", nil, headers: request_headers)
        Xendit::Response.handle_error_response resp

        JSON.parse resp.body
      end

      def create(payment_request_params, headers: {})
        # validation
        raise ArgumentError, 'payment_request_params is required' \
            if payment_request_params.nil? || payment_request_params.empty?

        # Validate required fields based on type
        validate_required_fields(payment_request_params)

        # Build headers
        request_headers = build_headers(headers)

        resp = Xendit::APIOperations.post(
          'v3/payment_requests',
          headers: request_headers,
          **payment_request_params
        )
        Xendit::Response.handle_error_response resp

        JSON.parse resp.body
      end

      private

      def validate_required_fields(params)
        validate_presence_and_type(params, :reference_id, String)
        validate_inclusion(params, :type, %w[PAY PAY_AND_SAVE REUSABLE_PAYMENT_CODE])
        validate_inclusion(params, :country, %w[ID PH VN TH SG MY])
        validate_inclusion(params, :currency, %w[IDR PHP VND THB SGD MYR USD])
        validate_presence_and_type(params, :channel_code, String)
        validate_presence_and_type(params, :channel_properties, Hash)

        # request_amount is required only if type is not REUSABLE_PAYMENT_CODE
        return if params[:type] == 'REUSABLE_PAYMENT_CODE'

        validate_request_amount(params[:request_amount])
      end

      def build_headers(custom_headers)
        headers = {}
        headers['api-version'] = custom_headers[:api_version] || custom_headers['api-version'] || '2024-11-11'
        headers
      end

      def validate_presence_and_type(params, key, type)
        value = params[key]
        raise ArgumentError, "#{key} is required and should be a #{type}" if value.nil? || !value.is_a?(type)
      end

      def validate_inclusion(params, key, allowed_values)
        value = params[key]
        raise ArgumentError, "#{key} is required and should be one of: #{allowed_values.join(', ')}" \
            if value.nil? || !allowed_values.include?(value)
      end

      def validate_request_amount(amount)
        raise ArgumentError, 'request_amount is required and should be a number' \
            if amount.nil? || (!amount.is_a?(Integer) && !amount.is_a?(Float))
        raise ArgumentError, 'request_amount must be greater than or equal to 0' if amount.negative?
      end
    end
  end
end
