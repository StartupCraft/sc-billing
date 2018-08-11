# frozen_string_literal: true

module SC::Billing::Stripe::Customers::Subscriptions
  class CreateOperation < ::SC::Billing::BaseOperation
    def call(event)
      subscription_data = event.respond_to?(:data) ? event.data.object : event
      user = find_user(subscription_data.customer)
      return unless user

      create_subscription(user, subscription_data)
    end

    private

    def find_user(customer_id)
      user_model.first(stripe_customer_id: customer_id)
    end

    def create_subscription(user, subscription_data)
      plans = find_plans(subscription_data)
      try_to_find_products(subscription_data)

      ::SC::Billing::Subscriptions::CreateOperation.new.call(
        subscription_data,
        user: user,
        plan_pks: plans.pluck(:id),
        stripe_id: subscription_data.id
      )
    end

    def find_entities_by_stripe_ids(type:, stripe_ids:)
      type_class = "SC::Billing::#{type.to_s.classify}".constantize

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
