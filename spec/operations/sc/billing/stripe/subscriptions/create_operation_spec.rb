# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscriptions::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user, items: [{plan: plan.id}])
  end

  let(:stripe_customer) { Stripe::Customer.create(source: stripe_helper.generate_card_token) }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:plan) { stripe_helper.create_plan }

  it 'creates payment source', :aggregate_failures do
    expect { call }.to change(::SC::Billing::Subscription, :count).by(1)

    is_expected.to be_success
  end

  context 'when stripe raise error' do
    before do
      error = Stripe::InvalidRequestError.new('Some error', nil)
      StripeMock.prepare_error(error, :create_subscription)
    end

    it 'returns failure' do
      is_expected.to be_failure
    end
  end
end
