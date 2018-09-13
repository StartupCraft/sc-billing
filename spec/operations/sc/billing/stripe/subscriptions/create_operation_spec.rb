# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscriptions::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user, subscription_params)
  end

  let(:subscription_params) { {items: [{plan: plan.id}]} }

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:plan) { stripe_helper.create_plan }

  it 'creates subscription', :aggregate_failures do
    expect { call }.to change(::SC::Billing::Stripe::Subscription, :count).by(1)

    expect(call).to be_success
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

      it 'does not create subscription with coupon', :aggregate_failures do
        expect(call).to be_failure
      end
    end
  end

  context 'when Stripe::InvalidRequestError was raised' do
    before do
      error = Stripe::InvalidRequestError.new('Some error', nil)
      StripeMock.prepare_error(error, :create_subscription)
    end

    it 'returns failure' do
      expect(call).to be_failure
    end
  end

  context 'when Stripe::CardError was raised' do
    before do
      error = Stripe::CardError.new('Some error', nil, 402)
      StripeMock.prepare_error(error, :create_subscription)
    end

    it 'returns failure' do
      expect(call).to be_failure
    end
  end
end
