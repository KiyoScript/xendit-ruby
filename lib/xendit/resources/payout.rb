# frozen_string_literal: true

require 'faraday'
require 'json'

require_relative '../api_operations'
require_relative '../response'
require_relative '../payout/validator'

module Xendit
  class Payout
    class << self
      def get(payout_id, headers: {})
        Validator.validate_payout_id(payout_id)
        request_headers = build_headers(headers)

        resp = Xendit::APIOperations.get("v2/payouts/#{payout_id}", nil, headers: request_headers)
        Xendit::Response.handle_error_response resp

        JSON.parse resp.body
      end

      def get_by_reference_id(reference_id, headers: {})
        raise ArgumentError, 'reference_id is required and should be a string' \
          if reference_id.nil? || !reference_id.is_a?(String)

        request_headers = build_headers(headers)
        params = {reference_id: reference_id}

        resp = Xendit::APIOperations.get('v2/payouts', params, headers: request_headers)
        Xendit::Response.handle_error_response resp

        JSON.parse resp.body
      end

      def create(payout_params, headers: {})
        raise ArgumentError, 'payout_params is required' \
          if payout_params.nil? || payout_params.empty?

        Validator.validate_payout_params(payout_params)
        request_headers = build_headers(headers, payout_params)

        resp = Xendit::APIOperations.post(
          'v2/payouts',
          headers: request_headers,
          **payout_params
        )
        Xendit::Response.handle_error_response resp

        JSON.parse resp.body
      end

      private

      def build_headers(custom_headers, payout_params = {})
        headers = {}

        # Idempotency-key is required (1-100 characters)
        idempotency_key = custom_headers[:idempotency_key] ||
                          custom_headers['Idempotency-key'] ||
                          payout_params[:reference_id]

        raise ArgumentError, 'Idempotency-key is required in headers' if idempotency_key.nil?

        Validator.validate_string_length(idempotency_key, 'Idempotency-key', 1, 100)
        headers['Idempotency-key'] = idempotency_key
        headers
      end
    end
  end
end
