# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_subscribed_plan, class: 'SC::Billing::Stripe::SubscribedPlan' do
    to_create(&:save)

    association :subscription, factory: :stripe_subscription
    association :plan, factory: :stripe_plan
  end
end
