# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Invoices::UpdateOperation, :stripe do
  describe '#call' do
    subject(:call) do
      described_class.new.call(invoice, invoice_data)
    end

    let!(:invoice_data) do
      ::Stripe::Invoice.create(invoice_pdf: 'somelink', amount_paid: 100)
    end

    let!(:invoice) { create(:stripe_invoice, stripe_id: invoice_data.id, amount_paid: 0) }

    it 'updates invoice' do
      expect { call }.to(
        change { invoice.reload.amount_paid }.to(100)
      )
    end
  end
end
