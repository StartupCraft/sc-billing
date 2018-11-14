# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Invoices
  class PaymentSucceededOperation < ::SC::Billing::Stripe::Webhooks::Invoices::UpdateOperation
    set_event_type 'invoice.payment_succeeded'
  end
end
