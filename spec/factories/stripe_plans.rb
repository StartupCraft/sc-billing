# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_plan, class: 'SC::Billing::Stripe::Plan' do
    to_create(&:save)

    name { FFaker::Lorem.word }
    stripe_id { SecureRandom.hex }
    amount { rand(10_000) }
    currency 'usd'

    association :product, factory: :stripe_product
  end
end
