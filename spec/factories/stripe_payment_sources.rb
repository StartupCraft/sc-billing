# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_payment_source, class: 'SC::Billing::Stripe::PaymentSource' do
    to_create(&:save)

    object 'card'
    type 'card'
    status 'chargeable'
    stripe_id { SecureRandom.hex }
    user
  end
end
