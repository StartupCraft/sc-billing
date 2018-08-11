# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Customers::Subscriptions::UpdateOperation do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.subscription.updated') }

  around do |example|
    StripeMock.start

    example.run

    StripeMock.stop
  end

  context 'when subscription exists' do
    let!(:user) { create(:user, stripe_customer_id: 'cus_CcFlMeAV92yGep') }
    let!(:subscription) do
      create(:subscription, :active, user: user, stripe_id: 'sub_CcFmXH410WdGp1')
    end

    context 'when not all plans exist in sysmem' do
      it 'raises error' do
        expect { result }.to raise_error('There is no enough plans in system')
      end
    end

    context 'when not all products exist in system' do
      before do
        create(:plan, name: 'community', stripe_id: 'community')
        create(:plan, name: 'jobs', stripe_id: 'jobs')
        create(:plan, name: 'management', stripe_id: 'management')
      end

      it 'raises error' do
        expect { result }.to raise_error('There is no enough products in system')
      end
    end

    context 'when plans exist in system' do
      before do
        product = create(:product, name: 'Community', stripe_id: 'prod_CaU68FIxzsRMPa')
        create(:plan, product: product, name: 'Community', stripe_id: 'community')

        product = create(:product, name: 'Jobs', stripe_id: 'prod_CaU6kvMMYsMPsC')
        create(:plan, product: product, name: 'jobs', stripe_id: 'jobs')

        product = create(:product, name: 'management', stripe_id: 'prod_CZ1Eu8jADpfJtt')
        create(:plan, product: product, name: 'Management', stripe_id: 'management')
      end

      it 'updates subscription', :aggregate_failures do
        expect { result }.to(
          change { subscription.reload.plans }.from([]).to(::SC::Billing::Plan.all)
          .and(change { subscription.reload.status }.from('active').to('canceled'))
          .and(change { subscription.reload.products }.from([]).to(::SC::Billing::Product.all))
          .and(change { subscription.reload.current_period_start_at })
          .and(change { subscription.reload.current_period_end_at })
          .and(not_change { subscription.reload.trial_start_at })
          .and(not_change { subscription.reload.trial_end_at })
          .and(change { subscription.reload.stripe_data })
        )
      end
    end
  end

  context 'when customer not exists' do
    it 'does not do anything' do
      expect(result).to be_nil
    end
  end
end
