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
        nickname: 'Management',
        product: 'prod_1',
        amount: 100,
        curreny: 'usd'
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
      before do
        create(:stripe_plan, stripe_id: 'management', name: 'Management')
      end

      it 'not creates plans' do
        expect { call }.not_to change(::SC::Billing::Stripe::Plan, :count)
      end
    end
  end
end
