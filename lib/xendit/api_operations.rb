# frozen_string_literal: true

require 'faraday'
require 'json'

module Xendit
  class APIOperations
    class << self
      def get(url, params = nil, headers: {})
        conn = create_connection(headers)
        conn.get url, params
      end

      def post(url, headers: {}, **params)
        conn = create_connection(headers)
        conn.post url, JSON.generate(params)
      end

      private

      def create_connection(custom_headers = {})
        Faraday.new(
          url: Xendit.base_url,
          headers: default_headers.merge(custom_headers)
        ) do |conn|
          conn.basic_auth(Xendit.api_key, '')
        end
      end

      def default_headers
        {'Content-Type' => 'application/json'}
      end
    end
  end
end
