# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers::Subscriptions
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'customer.subscription.created'

    def call(event)
      run_before_hook(event: event)

      subscription_data = fetch_data(event)
      customer_id = subscription_data.customer
      user = find_user(customer_id)

      raise_if_user_not_found(user, customer_id)

      create_subscription(user, subscription_data).tap do |subscription|
        run_after_hook(subscription: subscription, user: user)
      end
    end

    private

    def create_subscription(user, subscription_data)
      subscription = find_subscription(subscription_data.id)
      return subscription if subscription

      plans = find_plans(subscription_data)
      try_to_find_products(subscription_data)

      ::SC::Billing::Subscriptions::CreateOperation.new.call(
        subscription_data,
        user: user,
        plan_pks: plans.pluck(:id),
        stripe_id: subscription_data.id
      )
    end

    def find_subscription(stripe_id)
      ::SC::Billing::Stripe::Subscription.first(stripe_id: stripe_id)
    end

    def find_entities_by_stripe_ids(type:, stripe_ids:)
      type_class = "SC::Billing::Stripe::#{type.to_s.classify}".constantize

      type_class.where(stripe_id: stripe_ids).all.tap do |entities|
        raise "There is no enough #{type.to_s.pluralize} in system" if entities.size != stripe_ids.size
      end
    end

    def find_plans(subscription_data)
      ids = subscription_data.items.data.map { |item| item.plan.id }

      find_entities_by_stripe_ids(type: :plan, stripe_ids: ids)
    end

    def try_to_find_products(subscription_data)
      ids = subscription_data.items.data.map { |item| item.plan.product }

      find_entities_by_stripe_ids(type: :product, stripe_ids: ids)
    end
  end
end
