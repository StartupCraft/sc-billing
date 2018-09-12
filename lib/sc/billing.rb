# frozen_string_literal: true

require 'sc/billing/railtie'
require 'sc/billing/engine'

require 'dry-auto_inject'
require 'dry-container'
require 'dry-transaction'
require 'dry-monads'
require 'stripe'
require 'transproc'

require 'sc/billing/import'
require 'sc/billing/transform'

module SC
  module Billing
    extend Dry::Configurable

    setting(:stripe_api_key, reader: true) { |value| Stripe.api_key = value }
    setting(:stripe_webhook_secret, reader: true)
    setting(:user_model_name, reader: true)
    setting(:custom_event_handlers, {}, reader: true)
    setting(:available_events, [], reader: true)
    setting(:event_hooks, {}, reader: true)

    class << self
      def user_model
        return @user_model if defined?(@user_model)

        @user_model = user_model_name.safe_constantize
      end
    end
  end
end
