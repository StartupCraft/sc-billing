# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::SyncInvoicesService, :stripe do
  let(:service) { described_class.new }
  let(:stripe_helper) { StripeMock.create_test_helper }

  describe '#call' do
    subject(:call) do
      service.call
    end

    let!(:stripe_invoice) do
      ::Stripe::Invoice.create(customer: 'cus_1', subscription: 'sub_1', invoice_pdf: 'somelink', amount_paid: 0)
    end

    before do
      create(:stripe_subscription, stripe_id: stripe_invoice.subscription)
      create(:user, stripe_customer_id: stripe_invoice.customer)
    end

    it 'creates invoice and invoice item' do
      expect { call }.to(
        change { ::SC::Billing::Stripe::Invoice.count }.by(1)
          .and(change { ::SC::Billing::Stripe::InvoiceItem.count }.by(1))
      )
    end

    context 'when invoice already exists' do
      let!(:invoice) { create(:stripe_invoice, stripe_id: stripe_invoice.id) }

      it 'updates invoice' do
        expect { call }.to(
          change { invoice.reload.pdf_url }.to(stripe_invoice.invoice_pdf)
        )
      end
    end
  end
end
