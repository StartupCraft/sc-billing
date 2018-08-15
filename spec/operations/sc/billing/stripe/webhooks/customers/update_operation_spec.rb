# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::UpdateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.updated') }
  let(:customer) { event.data.object }

  context 'when customer exists' do
    let!(:user) { create(:user, stripe_customer_id: customer.id) }

    context 'when new default payment source is not empty' do
      let!(:payment_source) { create(:stripe_payment_source, stripe_id: customer.default_source) }

      it 'changes user', :aggregate_failures do
        expect { call }.to(
          change { user.reload.default_stripe_payment_source }.to(payment_source)
        )
      end
    end

    context 'when new default payment source is empty' do
      let!(:user) { create(:user, :with_payment_source, stripe_customer_id: customer.id) }

      before do
        event.data.object.default_source = nil
      end

      it 'changes user' do
        expect { call }.to(
          change { user.reload.default_stripe_payment_source }.to(nil)
        )
      end
    end
  end

  context 'when customer does not exist' do
    it 'does not do anything' do
      expect(call).to be_nil
    end
  end
end
