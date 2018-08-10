# frozen_string_literal: true

FactoryBot.define do
  factory :plan, class: 'SC::Billing::Plan' do
    to_create(&:save)

    name { FFaker::Lorem.word }
    stripe_id { SecureRandom.hex }
    amount { rand(10_000) }
    currency 'usd'

    product
  end
end
