# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers::Subscriptions
  class UpdateOperation < ::SC::Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation
    include ::SC::Billing::Import['helpers.from_timestamp_to_time']

    set_event_type 'customer.subscription.updated'

    def call(event)
      run_before_hook(event: event)

      subscription_data = fetch_data(event)
      subscription = find_subscription(subscription_data.id)
      return unless subscription

      update_subscription(subscription, subscription_data).tap do |updated_subscription|
        run_after_hook(event: event, subscription: updated_subscription)
      end
    end

    private

    def find_subscription(subscription_id)
      ::SC::Billing::Stripe::Subscription.first(stripe_id: subscription_id)
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
