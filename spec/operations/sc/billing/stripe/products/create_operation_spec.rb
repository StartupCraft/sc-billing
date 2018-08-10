# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Products::CreateOperation do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('product.created') }
  let(:product) { event.data.object }

  around do |example|
    StripeMock.start

    example.run

    StripeMock.stop
  end

  context 'when product already exists' do
    before do
      create(:product, stripe_id: product.id)
    end

    it 'not raise error' do
      expect { call }.not_to raise_error
    end
  end

  context 'when product does not exist' do
    it 'creates product', :aggregate_failures do
      expect { call }.to change(::SC::Billing::Product, :count).by(1)
    end
  end
end
