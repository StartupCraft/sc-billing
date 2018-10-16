# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::Subscriptions
  class CancelOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(subscription)
      Try(Stripe::InvalidRequestError) do
        subscription_data = cancel_in_stripe(subscription)
        actualize_subscription(subscription, subscription_data)
      end
    end

    private

    def cancel_in_stripe(subscription)
      stripe_subscription = ::Stripe::Subscription.retrieve(subscription.stripe_id)
      stripe_subscription.cancel_at_period_end = true
      stripe_subscription.save
    end

    def actualize_subscription(subscription, subscription_data)
      ::SC::Billing::Subscriptions::UpdateOperation.new(subscription: subscription).call(subscription_data)
    end
  end
end
