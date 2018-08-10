# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Plans::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('plan.created') }
  let(:plan) { event.data.object }

  context 'when plan already exists' do
    before do
      create(:plan, stripe_id: plan.id)
    end

    it 'not raise error' do
      expect { call }.not_to raise_error
    end
  end

  context 'when plan does not exist' do
    context 'when product does not exist in system' do
      it { expect { call }.to raise_error('There is no product with id: prod_Cmpsds2X8lxkG0 in system') }
    end

    context 'when product exists in system' do
      let!(:product) { create(:product, stripe_id: 'prod_Cmpsds2X8lxkG0') }

      it 'creates plan', :aggregate_failures do
        expect { call }.to change(::SC::Billing::Plan, :count).by(1)

        created_plan = ::SC::Billing::Plan.last
        expect(created_plan.product).to eq(product)
        expect(created_plan.amount).to eq(3400)
        expect(created_plan.currency).to eq('usd')
      end
    end
  end
end
