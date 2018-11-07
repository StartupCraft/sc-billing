# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Invoices
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'invoice.payment_succeeded'

    def call(event)
      invoice_data = fetch_data(event)
      customer_id = invoice_data.customer
      user = find_user(customer_id)

      raise_if_user_not_found(user, customer_id)

      create_invoice(user, invoice_data).tap do |invoice|
        run_after_hook(invoice, user)
      end
    end

    private

    def create_invoice(user, invoice_data)
      ::SC::Billing::Stripe::Invoices::CreateOperation.new.call(
        invoice_data,
        user: user
      )
    end
  end
end
