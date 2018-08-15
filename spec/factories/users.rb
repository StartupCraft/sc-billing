# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: SC::Billing.user_model do
    to_create(&:save)

    email { FFaker::Internet.email }

    trait :with_payment_source do
      association :default_stripe_payment_source, factory: :stripe_payment_source
    end
  end
end
