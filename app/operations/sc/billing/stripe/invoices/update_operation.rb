# frozen_string_literal: true

module SC::Billing::Stripe::Invoices
  class UpdateOperation < ::SC::Billing::Stripe::Invoices::CreateOperation
    def call(invoice, invoice_data)
      Transformer.new.call(invoice_data).yield_self do |invoice_params|
        invoice.set(invoice_params).save
      end
    end
  end
end
