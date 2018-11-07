# frozen_string_literal: true

module SC::Billing::Stripe::Invoices
  class UpdateOperation < ::SC::Billing::BaseOperation
    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[]
    end

    def call(invoice, invoice_data)
      Transformer.new.call(invoice_data).yield_self do |invoice_params|
        invoice.update(invoice_params)
      end
    end
  end
end
