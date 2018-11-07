# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Invoices
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'invoice.payment_succeeded'

    def call(event)
      invoice_data = fetch_data(event)
      customer_id = invoice_data.customer
      user = find_user(customer_id)

      raise "There is no user with customer_id: #{customer_id} in system" unless user

      create_invoice(user, invoice_data).tap do |invoice|
        run_after_hook(invoice, user)
      end
    end

    private

    def find_user(customer_id)
      user_model.first(stripe_customer_id: customer_id)
    end

    def create_invoice(user, invoice_data)
      ::SC::Billing::Stripe::Invoices::CreateOperation.new.call(
        invoice_data,
        user: user
      )
    end
  end
end
