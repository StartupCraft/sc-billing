# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::Subscriptions
  class EstimateOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(user, items:, coupon: nil)
      Try(Stripe::InvalidRequestError) do
        estimate(user, items, coupon)
      end
    end

    private

    def estimate(user, items, coupon)
      ::Stripe::Invoice.upcoming(customer: user.stripe_customer_id, subscription_items: items, coupon: coupon)
    end
  end
end
