# frozen_string_literal: true

FactoryBot.define do
  factory :payment_source, class: 'SC::Billing::PaymentSource' do
    to_create(&:save)

    object 'card'
    type 'card'
    status 'chargeable'
    stripe_id { SecureRandom.hex }
    user
  end
end
