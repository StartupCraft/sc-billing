# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.created') }
  let(:customer) { event.data.object }

  context 'when user does not exist' do
    it 'creates user and company', :aggregate_failures do
      expect { call }.to(
        change(SC::Billing.user_model, :count).by(1)
      )

      expect(
        SC::Billing.user_model.first[SC::Billing.registration_source.field_name]
      ).to eq(SC::Billing::Constants::USERS_CREATED_IN_STRIPE_TYPE)
    end
  end

  context 'when user already exists' do
    let!(:user) { create(:user, email: event.data.object.email) }

    it 'updates user' do
      expect { call }.to change { user.reload.stripe_customer_id }.to(customer.id)
    end
  end
end
