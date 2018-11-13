# frozen_string_literal: true

module SC::Billing::Stripe
  class SyncInvoicesService
    def call
      ::Stripe::Invoice.all.auto_paging_each.each(&method(:create_or_actualize_invoice))
    end

    private

    def create_or_actualize_invoice(invoice_data)
      invoice = find_invoice(invoice_data.id)

      if invoice.nil?
        create_invoice(invoice_data)
      else
        actualize_invoice(invoice, invoice_data)
      end
    end

    def find_invoice(stripe_id)
      ::SC::Billing::Stripe::Invoice.find(stripe_id: stripe_id)
    end

    def create_invoice(data)
      ::SC::Billing::Stripe::Invoices::CreateOperation.new.call(data)
    end

    def actualize_invoice(invoice, data)
      ::SC::Billing::Stripe::Invoices::UpdateOperation.new.call(invoice, data)
    end
  end
end
