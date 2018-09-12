# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::PaymentSources::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user, token)
  end

  let(:stripe_customer) { Stripe::Customer.create }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:token) { stripe_helper.generate_card_token }

  it 'creates payment source', :aggregate_failures do
    expect { call }.to change(::SC::Billing::Stripe::PaymentSource, :count).by(1)

    expect(call).to be_success
  end

  context 'when stripe raise error' do
    before do
      error = Stripe::InvalidRequestError.new('No such token', nil)
      StripeMock.prepare_error(error, :create_source)
    end

    it 'returns failure' do
      expect(call).to be_failure
    end
  end
end
