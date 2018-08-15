# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Products::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('product.created') }
  let(:product) { event.data.object }

  context 'when product already exists' do
    before do
      create(:stripe_product, stripe_id: product.id)
    end

    it 'not raise error' do
      expect { call }.not_to raise_error
    end
  end

  context 'when product does not exist' do
    it 'creates product', :aggregate_failures do
      expect { call }.to change(::SC::Billing::Stripe::Product, :count).by(1)
    end
  end
end
