# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::PaymentSources::DestroyOperation, :stripe do
  subject(:call) do
    described_class.new.call(payment_source)
  end

  let(:stripe_customer) { Stripe::Customer.create }
  let(:user) { create(:user, stripe_customer_id: stripe_customer.id) }
  let(:stripe_payment_source) { stripe_customer.sources.create(source: stripe_helper.generate_card_token) }
  let!(:payment_source) { create(:stripe_payment_source, user: user, stripe_id: stripe_payment_source.id) }

  it 'deletes payment source', :aggregate_failures do
    expect { call }.to change(::SC::Billing::Stripe::PaymentSource, :count).by(-1)

    expect(call).to be_success
  end

  context 'when stripe raise error' do
    before do
      error = Stripe::InvalidRequestError.new('Some error', nil)
      StripeMock.prepare_error(error, :delete_source)
    end

    it 'returns failure' do
      expect(call).to be_failure
    end
  end
end
