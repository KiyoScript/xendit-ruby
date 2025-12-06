# frozen_string_literal: true

require_relative 'errors'

module Xendit
  class Response
    class << self
      # rubocop:disable Metrics/AbcSize
      def handle_error_response(resp)
        # validation
        raise ArgumentError, 'response is required' \
            if resp.nil?
        raise ArgumentError, 'response is in invalid format' \
            if resp.status.nil? || resp.body.nil?

        return unless resp.status >= 400

        begin
          body = JSON.parse resp.body
          raise Xendit::APIError.new(body['error_code'], body['message'], resp.status)
        rescue JSON::ParserError
          raise Xendit::APIError.new('INVALID_RESPONSE_BODY_FORMAT', 'Response body is not in JSON format', 422)
        end
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
