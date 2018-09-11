# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::SyncPlansService, :stripe do
  let(:service) { described_class.new }
  let(:stripe_helper) { StripeMock.create_test_helper }

  describe '#call' do
    subject(:call) do
      service.call
    end

    before do
      stripe_helper.create_plan(
        id: 'management',
        nickname: 'New Management',
        product: 'prod_1',
        amount: 100,
        curreny: 'usd',
        interval: 'year',
        interval_count: 2,
        trial_period_days: 1
      )
    end

    context 'when product doest no exists in system' do
      it 'raises error' do
        expect { call }.to raise_error('There is no product with id: prod_1 in system')
      end
    end

    context 'when plans do not exists' do
      before do
        create(:stripe_product, stripe_id: 'prod_1')
      end

      it 'creates plans' do
        expect { call }.to change(::SC::Billing::Stripe::Plan, :count).by(1)
      end
    end

    context 'when plans already exists' do
      let!(:stripe_plan) { create(:stripe_plan, stripe_id: 'management', name: 'Management', currency: 'cad') }

      it 'not creates plans', :aggregate_failures do
        expect { call }.to(
          not_change(::SC::Billing::Stripe::Plan, :count)
            .and(change { stripe_plan.reload.name }.to('New Management'))
            .and(change { stripe_plan.reload.currency }.to('usd'))
            .and(change { stripe_plan.reload.interval }.to('year'))
            .and(change { stripe_plan.reload.interval_count }.to(2))
            .and(change { stripe_plan.reload.trial_period_days }.to(1))
        )
      end
    end
  end
end
