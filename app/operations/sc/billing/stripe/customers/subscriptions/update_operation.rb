# frozen_string_literal: true

module SC::Billing::Stripe::Customers::Subscriptions
  class UpdateOperation < CreateOperation
    include ::SC::Billing::Import['helpers.from_timestamp_to_time']

    def call(event)
      subscription_data = event.respond_to?(:data) ? event.data.object : event
      subscription = find_subscription(subscription_data.id)
      return unless subscription

      update_subscription(subscription, subscription_data)
    end

    private

    def find_subscription(subscription_id)
      ::SC::Billing::Subscription.first(stripe_id: subscription_id)
    end

    def update_subscription(subscription, subscription_data)
      plans = find_plans(subscription_data)
      try_to_find_products(subscription_data)

      ::SC::Billing::Subscriptions::UpdateOperation
        .new(subscription: subscription)
        .call(subscription_data, plan_pks: plans.pluck(:id))
    end
  end
end
