# frozen_string_literal: true

module SC::Billing::Stripe::Customers::Subscriptions
  class DeleteOperation < ::SC::Billing::Stripe::Customers::Subscriptions::UpdateOperation
    private

    def update_subscription(subscription, subscription_data)
      subscription.update(status: subscription_data.status)
    end
  end
end
