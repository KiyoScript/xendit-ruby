# frozen_string_literal: true

module Xendit
  class APIError < StandardError
    attr_reader :error_code, :error_message, :http_status

    def initialize(error_code, error_message, http_status)
      @error_code = error_code
      @error_message = error_message
      @http_status = http_status

      super(to_s)
    end

    def to_s
      status_string = @http_status.nil? ? '' : "(Status #{@http_status}) "
      error_code_string = @error_code.nil? ? '' : "#{error_code} - "
      "#{status_string}#{error_code_string}#{@error_message}"
    end
  end
end
