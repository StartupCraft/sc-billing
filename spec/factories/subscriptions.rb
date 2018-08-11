# frozen_string_literal: true

FactoryBot.define do
  factory :subscription, class: 'SC::Billing::Subscription' do
    to_create(&:save)

    user
    stripe_id { SecureRandom.hex }
    status 'active'
    current_period_start_at { FFaker::Time.datetime }
    current_period_end_at { current_period_start_at + 1.month }
    stripe_data { {}.to_json }

    trait :active do
      status 'active'
    end

    trait :canceled do
      status 'canceled'
    end
  end
end
