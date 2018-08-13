# frozen_string_literal: true

module SC::Billing::Stripe
  class SyncSubscriptionsService
    def call
      ::Stripe::Subscription.all.data.each(&method(:create_or_actualize_subscription))
    end

    private

    def create_or_actualize_subscription(subscription_data)
      if subscription_exists?(subscription_data.id)
        actualize_subscription(subscription_data)
      else
        create_subscription(subscription_data)
      end
    end

    def subscription_exists?(stripe_id)
      !::SC::Billing::Subscription.where(stripe_id: stripe_id).empty?
    end

    def create_subscription(data)
      ::SC::Billing::Stripe::Customers::Subscriptions::CreateOperation.new.call(data)
    end

    def actualize_subscription(data)
      ::SC::Billing::Stripe::Customers::Subscriptions::UpdateOperation.new.call(data)
    end
  end
end
