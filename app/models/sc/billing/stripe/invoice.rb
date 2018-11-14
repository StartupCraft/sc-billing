# frozen_string_literal: true

module SC::Billing::Stripe
  class Invoice < Sequel::Model(:stripe_invoices)
    plugin :nested_attributes

    many_to_one :user, class_name: SC::Billing.user_model
    many_to_one :subscription, class: 'SC::Billing::Stripe::Subscription'
    one_to_many :items, class_name: 'SC::Billing::Stripe::InvoiceItem'

    nested_attributes :items
  end
end
