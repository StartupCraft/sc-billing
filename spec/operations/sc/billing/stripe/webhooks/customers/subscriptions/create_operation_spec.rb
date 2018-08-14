# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation, :stripe do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.subscription.created') }

  context 'when customer exists' do
    before do
      create(:user, stripe_customer_id: 'cus_CcFlMeAV92yGep')
    end

    context 'when not all plans exist in sysmem' do
      it 'raises error' do
        expect { result }.to raise_error('There is no enough plans in system')
      end
    end

    context 'when not all products exist in system' do
      before do
        create(:plan, name: 'Community', stripe_id: 'community')
        create(:plan, name: 'Jobs', stripe_id: 'jobs')
        create(:plan, name: 'Management', stripe_id: 'management')
      end

      it 'raises error' do
        expect { result }.to raise_error('There is no enough products in system')
      end
    end

    context 'when plans and products exist in system' do
      before do
        create(:plan, name: 'Community', stripe_id: 'community')
        create(:plan, name: 'Jobs', stripe_id: 'jobs')
        create(:plan, name: 'Management', stripe_id: 'management')

        create(:product, name: 'Community', stripe_id: 'prod_CaU68FIxzsRMPa')
        create(:product, name: 'Jobs', stripe_id: 'prod_CaU6kvMMYsMPsC')
        create(:product, name: 'Management', stripe_id: 'prod_CZ1Eu8jADpfJtt')
      end

      it 'creates subscription', :aggregate_failures do
        expect { result }.to(
          change(::SC::Billing::Subscription, :count).by(1)
          .and(change(::SC::Billing::SubscribedPlan, :count).by(3))
        )

        created_subscription = ::SC::Billing::Subscription.last
        expect(created_subscription.status).to eq('active')
        expect(created_subscription.stripe_id).not_to be_nil
        expect(created_subscription.stripe_data).not_to be_nil
      end
    end
  end

  context 'when customer not exists' do
    it 'does not do anything' do
      expect(result).to be_nil
    end
  end
end