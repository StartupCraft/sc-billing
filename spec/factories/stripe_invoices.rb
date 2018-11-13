# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_invoice, class: 'SC::Billing::Stripe::Invoice' do
    to_create(&:save)

    association :subscription, factory: :stripe_subscription
    user { subscription.user }

    stripe_id { SecureRandom.hex }
    stripe_data { {} }

    date { Time.current }
    due_date { Time.current }
    forgiven { FFaker::Boolean.random }
    closed { FFaker::Boolean.random }
    attempted { FFaker::Boolean.random }
    paid { FFaker::Boolean.random }
    amount_due { rand(1000) }
    amount_paid { rand(1000) }
    total { rand(1000) }
    currency { 'cad' }
    pdf_url { FFaker::Image.url }
  end
end
