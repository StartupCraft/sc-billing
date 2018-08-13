# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::SyncSubscriptionsService, :stripe do
  let(:service) { described_class.new }
  let(:stripe_helper) { StripeMock.create_test_helper }

  describe '#call' do
    subject(:call) do
      service.call
    end

    def double_subscription(subscription_id, plan, customer_id = nil)
      subscription_items = construct_subscription_items(plan)

      construct_subscription(subscription_id, customer_id, subscription_items)
    end

    def construct_subscription_items(plan)
      subscription_item = Stripe::SubscriptionItem.construct_from(plan: plan)
      Stripe::ListObject.construct_from(data: [subscription_item])
    end

    def construct_subscription(subscription_id, customer_id, subscription_items)
      Stripe::Subscription.construct_from(
        id: subscription_id,
        items: subscription_items,
        customer: customer_id,
        status: 'active',
        current_period_start: 1_528_385_032,
        current_period_end: 1_530_977_032,
        trial_start: nil,
        trial_end: nil
      )
    end

    before do
      plan = stripe_helper.create_plan(product: 'prod_1', id: 'plan_1')

      subscription = double_subscription('sub_1', plan)
      subscription2 = double_subscription('sub_2', plan, 'cus_1')
      subscriptions_list = Stripe::ListObject.construct_from(data: [subscription, subscription2])

      allow(Stripe::Subscription).to receive(:all).and_return(subscriptions_list)
    end

    let!(:subscription) { create(:subscription, :active, stripe_id: 'sub_1') }

    context 'when plan does not exist in system' do
      it 'raises error' do
        expect { call }.to raise_error('There is no enough plans in system')
      end
    end

    context 'when product does not exist in system' do
      before do
        create(:plan, stripe_id: 'plan_1')
      end

      it 'raises error' do
        expect { call }.to raise_error('There is no enough products in system')
      end
    end

    context 'when product exists in system' do
      let!(:product) { create(:product, stripe_id: 'prod_1') }

      before do
        create(:plan, product: product, stripe_id: 'plan_1')
        create(:user, stripe_customer_id: 'cus_1')
      end

      it 'actualizes subscriptions and creates new one' do
        expect { call }.to(
          change { subscription.reload.products }.from([]).to([product])
            .and(change { subscription.reload.current_period_start_at })
            .and(change { subscription.reload.current_period_end_at })
            .and(not_change { subscription.reload.trial_start_at })
            .and(not_change { subscription.reload.trial_end_at })
            .and(change { subscription.reload.stripe_data })
            .and(change { ::SC::Billing::Subscription.count }.by(1))
        )
      end
    end
  end
end
