# frozen_string_literal: true

module SC::Billing::Stripe::Subscriptions
  class CancelOperation < ::SC::Billing::BaseOperation
    def call(subscription)
      subscription_data = cancel_in_stripe(subscription)
      actualize_subscription(subscription, subscription_data)
    end

    private

    def cancel_in_stripe(subscription)
      ::Stripe::Subscription.retrieve(subscription.stripe_id).delete
    end

    def actualize_subscription(subscription, subscription_data)
      ::SC::Billing::Subscriptions::UpdateOperation.new(subscription: subscription).call(subscription_data)
    end
  end
end
