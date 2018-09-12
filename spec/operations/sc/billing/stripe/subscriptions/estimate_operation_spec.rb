# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscriptions::EstimateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user, subscription_params)
  end

  let(:subscription_params) { {items: [{plan: plan.id}]} }

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:plan) { stripe_helper.create_plan }

  before do
    allow(::Stripe::Invoice).to receive(:upcoming)
  end

  it 'estimates subscription', :aggregate_failures do
    expect(call).to be_success
    expect(::Stripe::Invoice).to have_received(:upcoming)
  end

  context 'when with coupon' do
    let(:subscription_params) { {items: [{plan: plan.id}], coupon: coupon} }

    context 'with valid coupon' do
      let(:coupon) { Stripe::Coupon.create(duration: 'forever').id }

      it 'estimates subscription', :aggregate_failures do
        expect(call).to be_success
        expect(::Stripe::Invoice).to have_received(:upcoming)
      end
    end

    context 'with invalid coupon' do
      let(:coupon) { SecureRandom.hex }

      before do
        allow(::Stripe::Invoice).to(
          receive(:upcoming)
            .with(any_args)
            .and_raise(Stripe::InvalidRequestError.new('coupon is invalid', {}))
        )
      end

      it 'does not estimate subscription', :aggregate_failures do
        expect(call).to be_failure
      end
    end
  end
end
