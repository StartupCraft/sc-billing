# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_plan, class: 'SC::Billing::Stripe::Plan' do
    to_create(&:save)

    name { FFaker::Lorem.word }
    stripe_id { SecureRandom.hex }
    amount { rand(10_000) }
    currency { 'usd' }
    interval { 'month' }
    interval_count { 1 }
    applicable { FFaker::Boolean.random }

    association :product, factory: :stripe_product
  end
end
