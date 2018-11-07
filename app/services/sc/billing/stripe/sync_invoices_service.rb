# frozen_string_literal: true

module SC::Billing::Stripe
  class SyncInvoicesService
    def call
      ::Stripe::Invoice.all.auto_paging_each.each(&method(:create_or_actualize_invoice))
    end

    private

    def create_or_actualize_invoice(invoice_data)
      if invoice_exists?(invoice_data.id)
        actualize_invoice(invoice_data)
      else
        create_invoice(invoice_data)
      end
    end

    def invoice_exists?(stripe_id)
      !::SC::Billing::Stripe::Invoice.where(stripe_id: stripe_id).empty?
    end

    def create_invoice(data)
      ::SC::Billing::Stripe::Invoices::CreateOperation.new.call(data)
    end

    def actualize_invoice(data)
      ::SC::Billing::Stripe::Invoices::UpdateOperation.new.call(data)
    end
  end
end
