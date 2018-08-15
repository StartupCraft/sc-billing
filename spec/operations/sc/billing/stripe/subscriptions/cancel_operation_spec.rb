# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscriptions::CancelOperation, :stripe do
  subject(:call) do
    described_class.new.call(subscription)
  end

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:stripe_subscription) { Stripe::Subscription.create(customer: stripe_customer.id) }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:subscription) { create(:stripe_subscription, user: user, stripe_id: stripe_subscription.id) }

  it 'cancels subscription' do
    expect { call }.to(change { subscription.reload.status }.to('canceled'))
  end
end
