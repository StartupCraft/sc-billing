# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::Subscriptions
  class CreateOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(user, items:)
      Try(Stripe::InvalidRequestError) do
        subscription_data = create_in_stripe(user, items)
        create_in_db(user, subscription_data)
      end
    end

    private

    def create_in_stripe(user, items)
      ::Stripe::Subscription.create(customer: user.stripe_customer_id, items: items)
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

      ::SC::Billing::Plan.where(stripe_id: ids)
    end
  end
end
