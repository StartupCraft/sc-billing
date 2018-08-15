# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Customers::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(user, token: token)
  end

  let(:user) { create(:user) }
  let(:token) { stripe_helper.generate_card_token }

  context 'when create with token' do
    it 'creates payment source', :aggregate_failures do
      expect { call }.to(change { user.reload.stripe_customer_id })

      is_expected.to be_success
    end
  end

  context 'when create without token' do
    subject(:call) do
      described_class.new.call(user)
    end

    it 'creates payment source', :aggregate_failures do
      expect { call }.to(change { user.reload.stripe_customer_id })

      is_expected.to be_success
    end
  end

  context 'when stripe raise error' do
    before do
      error = Stripe::InvalidRequestError.new('Some error', nil)
      StripeMock.prepare_error(error, :new_customer)
    end

    it 'returns failure' do
      is_expected.to be_failure
    end
  end
end
