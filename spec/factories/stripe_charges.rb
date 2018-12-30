# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_charge, class: 'SC::Billing::Stripe::Charge' do
    to_create(&:save)

    user

    stripe_id { SecureRandom.hex }
    stripe_data { {} }

    status { SC::Billing::Stripe::Charge::STATUSES.sample }

    paid { FFaker::Boolean.random }
    refunded { FFaker::Boolean.random }

    trait :pending do
      status { 'pending' }
      paid { false }
      refunded { false }
    end

    trait :succeeded do
      status { 'succeeded' }
      paid { true }
      refunded { false }
    end

    trait :refunded do
      status { 'refunded' }
      paid { true }
      refunded { true }
    end
  end
end
