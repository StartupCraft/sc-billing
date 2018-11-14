# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Invoices::CreateOperation, :stripe do
  describe '#call' do
    subject(:call) do
      described_class.new.call(stripe_invoice, extra_params)
    end

    let!(:stripe_invoice) do
      plan = stripe_helper.create_plan
      item = ::Stripe::InvoiceItem.create(plan: plan)
      items = Stripe::ListObject.construct_from(data: [item])

      ::Stripe::Invoice.create(
        customer: 'cus_1',
        subscription: 'sub_1',
        invoice_pdf: 'somelink',
        amount_paid: 0,
        lines: items
      )
    end
    let!(:user) { create(:user, stripe_customer_id: stripe_invoice.customer) }
    let!(:subscription) { create(:stripe_subscription, stripe_id: stripe_invoice.subscription) }

    let(:extra_params) { {} }

    before do
      allow(::SC::Billing::Stripe::Subscription).to receive(:find).and_call_original
      allow(::SC::Billing.user_model).to receive(:find).and_call_original
    end

    it 'creates invoice', :aggregate_failures do
      expect { call }.to(
        change(::SC::Billing::Stripe::Invoice, :count).by(1)
        .and(change(::SC::Billing::Stripe::InvoiceItem, :count).by(1))
      )
      expect(::SC::Billing::Stripe::Subscription).to have_received(:find)
      expect(::SC::Billing.user_model).to have_received(:find)
    end

    context 'when pass user and subscription through extra params' do
      let(:extra_params) { {user: user, subscription: subscription} }

      it 'creates invoice', :aggregate_failures do
        expect { call }.to(
          change(::SC::Billing::Stripe::Invoice, :count).by(1)
            .and(change(::SC::Billing::Stripe::InvoiceItem, :count).by(1))
        )
        expect(::SC::Billing::Stripe::Subscription).not_to have_received(:find)
        expect(::SC::Billing.user_model).not_to have_received(:find)
      end
    end
  end
end
