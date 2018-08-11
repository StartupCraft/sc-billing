# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Customers::Sources::UpdateOperation, :stripe do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.source.updated') }

  context 'when payment source exists' do
    let!(:payment_source) { create(:payment_source, stripe_id: event.data.object.id) }

    it 'updates payment source' do
      expect { result }.to(change { payment_source.reload.stripe_data })
    end
  end

  context 'when payment source does not exist' do
    it 'does not do anything' do
      expect(result).to be_nil
    end
  end
end
