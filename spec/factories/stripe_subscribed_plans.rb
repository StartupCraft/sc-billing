# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_subscribed_plan, class: 'SC::Billing::Stripe::SubscribedPlan' do
    to_create(&:save)

    subscription
    plan
  end
end
