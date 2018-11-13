# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Invoices
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'invoice.created'

    def call(event)
      invoice_data = fetch_data(event)

      user = find_or_raise_user(invoice_data.customer)
      subscription = find_or_raise_subscription(invoice_data.subscription)

      create_invoice(user, subscription, invoice_data).tap do |invoice|
        run_after_hook(invoice: invoice, user: user)
      end
    end

    private

    def create_invoice(user, subscription, invoice_data)
      ::SC::Billing::Stripe::Invoices::CreateOperation.new.call(
        invoice_data,
        user: user,
        subscription: subscription
      )
    end
  end
end
