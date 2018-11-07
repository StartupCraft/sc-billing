# frozen_string_literal: true

module SC::Billing::Stripe
  class Invoice < Sequel::Model(:stripe_invoices)
    many_to_one :user, class_name: SC::Billing.user_model
    many_to_one :subscription, class: 'SC::Billing::Stripe::Subscription'
    many_to_one :plan, class: 'SC::Billing::Stripe::Plan'
  end
end
