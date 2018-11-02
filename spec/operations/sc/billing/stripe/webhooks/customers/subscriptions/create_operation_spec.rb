# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation, :stripe do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.subscription.created') }
  let(:stripe_customer_id) { 'cus_CcFlMeAV92yGep' }

  context 'when customer exists' do
    before do
      create(:user, stripe_customer_id: stripe_customer_id)
    end

    context 'when not all plans exist in sysmem' do
      it 'raises error' do
        expect { result }.to raise_error('There is no enough plans in system')
      end
    end

    context 'when not all products exist in system' do
      before do
        create(:stripe_plan, name: 'Community', stripe_id: 'community')
        create(:stripe_plan, name: 'Jobs', stripe_id: 'jobs')
        create(:stripe_plan, name: 'Management', stripe_id: 'management')
      end

      it 'raises error' do
        expect { result }.to raise_error('There is no enough products in system')
      end
    end

    context 'when plans and products exist in system' do
      before do
        create(:stripe_plan, name: 'Community', stripe_id: 'community')
        create(:stripe_plan, name: 'Jobs', stripe_id: 'jobs')
        create(:stripe_plan, name: 'Management', stripe_id: 'management')

        create(:stripe_product, name: 'Community', stripe_id: 'prod_CaU68FIxzsRMPa')
        create(:stripe_product, name: 'Jobs', stripe_id: 'prod_CaU6kvMMYsMPsC')
        create(:stripe_product, name: 'Management', stripe_id: 'prod_CZ1Eu8jADpfJtt')
      end

      it 'creates subscription', :aggregate_failures do
        expect { result }.to(
          change(::SC::Billing::Stripe::Subscription, :count).by(1)
          .and(change(::SC::Billing::Stripe::SubscribedPlan, :count).by(3))
        )

        created_subscription = ::SC::Billing::Stripe::Subscription.last
        expect(created_subscription.status).to eq('active')
        expect(created_subscription.stripe_id).not_to be_nil
        expect(created_subscription.stripe_data).not_to be_nil
      end
    end

    context 'when subscription already exists' do
      before do
        create(:stripe_subscription, stripe_id: 'sub_CcFmXH410WdGp1')
      end

      it 'does not raise error' do
        expect { result }.not_to raise_error
      end
    end
  end

  context 'when customer not exists' do
    it 'does not do anything' do
      expect { result }.to raise_error("There is no user with customer_id: #{stripe_customer_id} in system")
    end
  end
end
