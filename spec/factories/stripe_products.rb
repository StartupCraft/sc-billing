# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_product, class: 'SC::Billing::Stripe::Product' do
    to_create(&:save)

    name { FFaker::Lorem.word }
    stripe_id { SecureRandom.hex }
  end
end
