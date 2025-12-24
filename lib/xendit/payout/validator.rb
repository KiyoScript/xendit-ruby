# frozen_string_literal: true

module Xendit
  class Payout
    module Validator
      class << self
        def validate_payout_id(payout_id)
          raise ArgumentError, 'payout_id is required and should be a string' \
            if payout_id.nil? || !payout_id.is_a?(String)

          raise ArgumentError, 'payout_id should be 29 characters long' \
            if payout_id.length != 29
        end

        def validate_payout_params(params)
          validate_core_fields(params)
          validate_channel_properties(params[:channel_properties])
          validate_optional_fields(params)
        end

        def validate_string_length(value, field_name, min_length, max_length)
          return unless value

          length = value.to_s.length
          return if length >= min_length && length <= max_length

          raise ArgumentError,
                "#{field_name} must be between #{min_length} and #{max_length} characters"
        end

        private

        def validate_core_fields(params)
          validate_presence_and_type(params, :reference_id, String)
          validate_string_length(params[:reference_id], 'reference_id', 1, 255)

          validate_presence_and_type(params, :channel_code, String)
          validate_presence_and_type(params, :channel_properties, Hash)
          validate_amount(params[:amount])
          validate_presence_and_type(params, :currency, String)
        end

        def validate_amount(amount)
          raise ArgumentError, 'amount is required and should be an Integer or Float' \
            unless amount.is_a?(Integer) || amount.is_a?(Float)

          raise ArgumentError, 'amount must be greater than or equal to 0' \
            if amount.negative?
        end

        def validate_optional_fields(params)
          validate_description(params[:description]) if params[:description]
          return unless params[:receipt_notification] || params[:metadata]

          validate_receipt_notification(params[:receipt_notification]) if params[:receipt_notification]
          validate_metadata(params[:metadata]) if params[:metadata]
        end

        def validate_channel_properties(properties)
          validate_required_channel_fields(properties)
          validate_channel_field_lengths(properties)
          validate_account_type(properties[:account_type]) if properties[:account_type]
        end

        def validate_required_channel_fields(properties)
          raise ArgumentError, 'channel_properties must contain account_holder_name' \
            unless properties[:account_holder_name]

          raise ArgumentError, 'channel_properties must contain account_number' \
            unless properties[:account_number]
        end

        def validate_channel_field_lengths(properties)
          validate_string_length(
            properties[:account_holder_name],
            'channel_properties.account_holder_name',
            1,
            100
          )

          validate_string_length(
            properties[:account_number],
            'channel_properties.account_number',
            1,
            100
          )
        end

        def validate_account_type(account_type)
          valid_types = %w[MOBILE_NO NATIONAL_ID PASSPORT BUSINESS_REGISTRATION BANK_ACCOUNT]
          return if valid_types.include?(account_type)

          raise ArgumentError, "account_type must be one of: #{valid_types.join(', ')}"
        end

        def validate_description(description)
          validate_string_length(description, 'description', 1, 100)
        end

        def validate_receipt_notification(notification)
          raise ArgumentError, 'receipt_notification must be a Hash' \
            unless notification.is_a?(Hash)

          %i[email_to email_cc email_bcc].each do |field|
            validate_email_field(notification, field)
          end
        end

        def validate_email_field(notification, field)
          return unless notification[field]

          raise ArgumentError, "#{field} must be an Array" \
            unless notification[field].is_a?(Array)

          raise ArgumentError, "#{field} can contain maximum 3 email addresses" \
            if notification[field].length > 3
        end

        def validate_metadata(metadata)
          return if metadata.nil?

          raise ArgumentError, 'metadata must be a Hash' \
            unless metadata.is_a?(Hash)

          raise ArgumentError, 'metadata can contain maximum 50 keys' \
            if metadata.keys.length > 50

          metadata.each do |key, value|
            validate_metadata_entry(key, value)
          end
        end

        def validate_metadata_entry(key, value)
          raise ArgumentError, "metadata key '#{key}' must be max 40 characters" \
            if key.to_s.length > 40

          raise ArgumentError, "metadata value for key '#{key}' must be max 500 characters" \
            if value.to_s.length > 500
        end

        def validate_presence_and_type(params, key, type)
          value = params[key]
          types = type.is_a?(Array) ? type : [type]

          return if value && types.any? { |t| value.is_a?(t) }

          type_names = types.map(&:to_s).join(' or ')
          raise ArgumentError, "#{key} is required and should be a #{type_names}"
        end
      end
    end
  end
end
