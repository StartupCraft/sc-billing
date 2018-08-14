# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::Sources::DeleteOperation, :stripe do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.source.deleted') }

  context 'when payment source exists' do
    let!(:payment_source) { create(:payment_source, stripe_id: event.data.object.id) }

    it 'deletes payment source' do
      expect { result }.to change(::SC::Billing::PaymentSource, :count).by(-1)
    end

    context 'when payment source is default payment source for user' do
      before do
        payment_source.user.update(default_payment_source: payment_source)
      end

      it 'deletes payment source' do
        expect { result }.to change(::SC::Billing::PaymentSource, :count).by(-1)
      end
    end
  end

  context 'when payment source does not exist' do
    it 'does not do anything' do
      expect(result).to be_nil
    end
  end
end
