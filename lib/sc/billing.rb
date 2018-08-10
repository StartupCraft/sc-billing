# frozen_string_literal: true

require 'sc/billing/railtie'
require 'sc/billing/engine'

require 'dry-transaction'
require 'stripe'

module SC
  module Billing
    extend Dry::Configurable

    setting :stripe_webhook_secret, reader: true
    setting :user_model_name, reader: true
    setting :custom_event_handlers, {}, reader: true

    class << self
      def user_model
        return @user_model if defined?(@user_model)

        @user_model = user_model_name.safe_constantize
      end
    end
  end
end
