# frozen_string_literal: true

module SC::Billing::Stripe
  class InvoiceItem < Sequel::Model(:stripe_invoice_items)
    many_to_one :plan, class: 'SC::Billing::Stripe::Plan'
    many_to_one :invoice, class: 'SC::Billing::Stripe::Invoice'
  end
end
