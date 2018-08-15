# frozen_string_literal: true

module SC::Billing::Stripe
  class SubscribedPlan < Sequel::Model(:stripe_subscribed_plans)
    many_to_one :subscription, class: 'SC::Billing::Stripe::Subscription'
    many_to_one :plan, class: 'SC::Billing::Stripe::Plan'
  end
end
