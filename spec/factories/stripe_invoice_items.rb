# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_invoice_item, class: 'SC::Billing::Stripe::InvoiceItem' do
    to_create(&:save)

    association :invoice, factory: :stripe_invoice
    association :plan, factory: :stripe_plan

    stripe_id { SecureRandom.hex }
    stripe_data { {} }

    amount { rand(10_000) }
    currency { 'usd' }
  end
end
