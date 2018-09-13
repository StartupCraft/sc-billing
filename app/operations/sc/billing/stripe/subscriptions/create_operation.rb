# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::Subscriptions
  class CreateOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(user, items:, coupon: nil)
      Try(Stripe::InvalidRequestError, Stripe::CardError) do
        subscription_data = create_in_stripe(user, items, coupon)
        create_in_db(user, subscription_data)
      end
    end

    private

    def create_in_stripe(user, items, coupon)
      ::Stripe::Subscription.create(customer: user.stripe_customer_id, items: items, coupon: coupon)
    end

    def create_in_db(user, subscription_data)
      plans = find_plans(subscription_data)

      ::SC::Billing::Subscriptions::CreateOperation.new.call(
        subscription_data,
        user: user,
        plan_pks: plans.pluck(:id),
        stripe_id: subscription_data.id
      )
    end

    def find_plans(subscription_data)
      ids = subscription_data.items.data.map { |item| item.plan.id }

      ::SC::Billing::Stripe::Plan.where(stripe_id: ids)
    end
  end
end
