# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscriptions::CancelOperation, :stripe do
  subject(:call) do
    described_class.new.call(subscription)
  end

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:stripe_subscription) { Stripe::Subscription.create(customer: stripe_customer.id, items: [plan: plan.id]) }
  let(:plan) { stripe_helper.create_plan }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:subscription) { create(:stripe_subscription, user: user, stripe_id: stripe_subscription.id) }

  before do
    canceled_subscription = stripe_subscription
    canceled_subscription.cancel_at_period_end = true
    canceled_subscription.canceled_at = Time.current.to_i

    allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_subscription)
    allow(stripe_subscription).to receive(:save).and_return(canceled_subscription)
  end

  it 'cancels subscription' do
    expect { call }.to(
      change { subscription.reload.cancel_at_period_end }.to(true)
        .and(change { subscription.reload.canceled_at }.from(nil))
    )
  end
end
