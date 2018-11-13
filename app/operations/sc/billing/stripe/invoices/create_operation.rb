# frozen_string_literal: true

module SC::Billing::Stripe::Invoices
  class CreateOperation < ::SC::Billing::BaseOperation
    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        id
        date
        due_date
        forgiven
        closed
        attempted
        paid
        amount_paid
        amount_due
        total
        currency
        invoice_pdf
      ]

      rename_keys id: :stripe_id, invoice_pdf: :pdf_url
      timestamp_to_time %i[date due_date]
    end

    def call(invoice_data, **_extra_params)
      return if invoice_exists?(invoice_data)

      create_invoice(invoice_data)
    end

    private

    def create_invoice(invoice_data)
      user = user_model.find(stripe_customer_id: invoice_data.customer)
      subscription = ::SC::Billing::Stripe::Subscription.find(stripe_id: invoice_data.subscription)

      Transformer.new.call(invoice_data).yield_self do |invoice_params|
        invoice_params[:user] = user
        invoice_params[:subscription] = subscription
        invoice_params[:items_attributes] = build_items_attributes(invoice_data)
        invoice_params[:stripe_data] = invoice_data.as_json

        ::SC::Billing::Stripe::Invoice.create(invoice_params)
      end
    end

    def build_items_attributes(invoice_data)
      invoice_data.lines.data.map(&method(:build_invoice_item))
    end

    def invoice_exists?(invoice_data)
      !::SC::Billing::Stripe::Invoice.where(stripe_id: invoice_data.id).empty?
    end

    def build_invoice_item(item_data)
      SC::Billing::Stripe::InvoiceItems::BuildOperation.new.call(item_data)
    end
  end
end
