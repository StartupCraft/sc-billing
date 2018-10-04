# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Plans::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('plan.created') }
  let(:plan) { event.data.object }

  context 'when plan already exists' do
    before do
      create(:stripe_plan, stripe_id: plan.id)
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
      let!(:product) { create(:stripe_product, stripe_id: 'prod_Cmpsds2X8lxkG0') }

      it 'creates plan', :aggregate_failures do
        expect { call }.to change(::SC::Billing::Stripe::Plan, :count).by(1)

        created_plan = ::SC::Billing::Stripe::Plan.last
        expect(created_plan.product).to eq(product)
        expect(created_plan.amount).to eq(3400)
        expect(created_plan.currency).to eq('usd')
        expect(created_plan.interval).to eq('month')
        expect(created_plan.interval_count).to eq(1)
        expect(created_plan.trial_period_days).to be_nil
        expect(created_plan).not_to be_applicable
      end
    end
  end
end
