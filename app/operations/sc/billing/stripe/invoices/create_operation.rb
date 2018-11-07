# frozen_string_literal: true

module SC::Billing::Stripe::Invoices
  class CreateOperation < ::SC::Billing::BaseOperation
    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        id
      ]

      rename_keys id: :stripe_id
    end

    def call(invoice_data, **extra_params)
      return if invoice_exists?(invoice_data)

      create_invoice(invoice_data)
    end

    private

    def create_invoice(product, invoice_data)
      Transformer.new.call(invoice_data).yield_self do |invoice_params|
        invoice_params[:product] = product
        invoice_params[:applicable] = false

        ::SC::Billing::Stripe::Invoice.create(invoice_params)
      end
    end

    def invoice_exists?(invoice_data)
      !::SC::Billing::Stripe::Invoice.where(stripe_id: invoice_data.id).empty?
    end
  end
end
