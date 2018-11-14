# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Invoices
  class UpdateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'invoice.updated'

    def call(event)
      invoice_data = fetch_data(event)

      invoice = find_or_raise_invoice(invoice_data.id)

      update_invoice(invoice, invoice_data).tap do |updated_invoice|
        run_after_hook(invoice: updated_invoice)
      end
    end

    private

    def update_invoice(invoice, invoice_data)
      SC::Billing::Stripe::Invoices::UpdateOperation.new.call(invoice, invoice_data)
    end

    def find_or_raise_invoice(stripe_id)
      find_invoice(stripe_id).tap do |invoice|
        raise_if_invoice_not_found(invoice, stripe_id)
      end
    end

    def find_invoice(stripe_id)
      ::SC::Billing::Stripe::Invoice.find(stripe_id: stripe_id)
    end

    def raise_if_invoice_not_found(invoice, stripe_id)
      raise "There is no invoice with stripe_id: #{stripe_id} in system" unless invoice
    end
  end
end
