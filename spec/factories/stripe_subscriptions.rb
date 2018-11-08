# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_subscription, class: 'SC::Billing::Stripe::Subscription' do
    to_create(&:save)

    user
    stripe_id { SecureRandom.hex }
    status { 'active' }
    current_period_start_at { FFaker::Time.datetime.to_datetime } # rubocop:disable Style/DateTime
    current_period_end_at { current_period_start_at + 1.month }
    stripe_data { {}.to_json }
    cancel_at_period_end { false }

    trait :active do
      status { 'active' }
    end

    trait :canceled do
      status { 'canceled' }
    end

    trait :trialing do
      status { 'trialing' }
    end

    trait :past_due do
      status { 'past_due' }
    end

    trait :unpaid do
      status { 'unpaid' }
    end
  end
end
