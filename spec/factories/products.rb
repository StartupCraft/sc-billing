# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: 'SC::Billing::Product' do
    to_create(&:save)

    name { FFaker::Lorem.word }
    stripe_id { SecureRandom.hex }
  end
end
