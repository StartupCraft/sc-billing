# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscriptions::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user, subscription_params)
  end

  let(:subscription_params) { {items: [{plan: plan.id}]} }

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:plan) { stripe_helper.create_plan }

  # rubocop:disable Metrics/MethodLength
  def construct_subscription(subscription_id, customer_id, subscription_items)
    Stripe::Subscription.construct_from(
      id: subscription_id,
      items: subscription_items,
      customer: customer_id,
      status: 'active',
      current_period_start: 1_528_385_032,
      current_period_end: 1_530_977_032,
      trial_start: nil,
      trial_end: nil,
      cancel_at_period_end: false,
      canceled_at: nil
    )
  end
  # rubocop:enable Metrics/MethodLength

  before do
    subscription_item = Stripe::SubscriptionItem.construct_from(plan: plan)
    subscription_items = Stripe::ListObject.construct_from(data: [subscription_item])

    subscription = construct_subscription('sub_1', stripe_customer.id, subscription_items)
    allow(::Stripe::Subscription).to receive(:create).and_return(subscription)
  end

  it 'creates subscription', :aggregate_failures do
    expect { call }.to change(::SC::Billing::Stripe::Subscription, :count).by(1)

    expect(call).to be_success

    expect(::Stripe::Subscription).to have_received(:create).with(hash_including(trial_from_plan: true))
  end

  context 'when with coupon' do
    let(:subscription_params) { {items: [{plan: plan.id}], coupon: coupon} }

    context 'with valid coupon' do
      let(:coupon) { Stripe::Coupon.create(duration: 'forever').id }

      it 'creates subscription with coupon', :aggregate_failures do
        expect { call }.to change(::SC::Billing::Stripe::Subscription, :count).by(1)

        expect(call).to be_success
      end
    end

    context 'with invalid coupon' do
      let(:coupon) { SecureRandom.hex }

      before do
        error = Stripe::InvalidRequestError.new('Some error', nil)

        allow(::Stripe::Subscription).to receive(:create).and_raise(error)
      end

      it 'does not create subscription with coupon', :aggregate_failures do
        expect(call).to be_failure
      end
    end
  end

  context 'when Stripe::InvalidRequestError was raised' do
    before do
      error = Stripe::InvalidRequestError.new('Some error', nil)

      allow(::Stripe::Subscription).to receive(:create).and_raise(error)
    end

    it 'returns failure' do
      expect(call).to be_failure
    end
  end

  context 'when Stripe::CardError was raised' do
    before do
      error = Stripe::CardError.new('Some error', nil, 402)

      allow(::Stripe::Subscription).to receive(:create).and_raise(error)
    end

    it 'returns failure' do
      expect(call).to be_failure
    end
  end
end
