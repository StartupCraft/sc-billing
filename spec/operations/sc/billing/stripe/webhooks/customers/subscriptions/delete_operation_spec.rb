# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Customers::Subscriptions::DeleteOperation, :stripe do
  subject(:result) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('customer.subscription.deleted') }

  context 'when subscription exists' do
    let!(:user) { create(:user, stripe_customer_id: 'cus_CcFlMeAV92yGep') }
    let!(:subscription) { create(:stripe_subscription, :active, user: user, stripe_id: 'sub_CcFmXH410WdGp1') }

    it 'updates subscription', :aggregate_failures do
      expect { result }.to(
        change { subscription.reload.status }.from('active').to('canceled')
      )
    end
  end

  context 'when customer not exists' do
    it 'does not do anything' do
      expect(result).to be_nil
    end
  end
end
