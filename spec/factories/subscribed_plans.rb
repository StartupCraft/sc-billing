# frozen_string_literal: true

FactoryBot.define do
  factory :subscribed_plan, class: 'SC::Billing::SubscribedPlan' do
    to_create(&:save)

    subscription
    plan
  end
end
