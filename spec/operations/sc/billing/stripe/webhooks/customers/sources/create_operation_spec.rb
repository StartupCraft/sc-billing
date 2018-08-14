# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::Sources::CreateOperation, :stripe do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.source.created') }

  context 'when customer exists' do
    before do
      create(:user, stripe_customer_id: event.data.object.customer)
    end

    it 'creates new payment source' do
      expect { result }.to change(::SC::Billing::PaymentSource, :count).by(1)
    end

    context 'when payment source already exists' do
      before do
        create(:payment_source, stripe_id: event.data.object.id)
      end

      it 'does not do anything' do
        expect(result).to be_nil
      end
    end
  end

  context 'when customer does not exist' do
    it 'does not do anything' do
      expect(result).to be_nil
    end
  end
end
