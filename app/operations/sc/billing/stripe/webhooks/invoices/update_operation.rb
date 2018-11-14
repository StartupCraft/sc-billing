# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Invoices
  class UpdateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    include SC::Billing::FindOrRaise[invoice: :stripe_id]
    include SC::Billing::Import[
      invoice_model: 'models.stripe.invoice'
    ]

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
  end
end
