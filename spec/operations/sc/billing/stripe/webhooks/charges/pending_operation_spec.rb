# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Charges::PendingOperation, :stripe do
  let(:webhook_operation) { described_class.new }

  describe '#call' do
    subject(:call) do
      webhook_operation.call(event)
    end

    let(:event) { StripeMock.mock_webhook_event('charge.pending') }
    let(:event_data) { event.data.object }

    context 'when charge exists' do
      let!(:charge) { create(:stripe_charge, stripe_id: 'ch_00000000000000') }

      it 'updates charge' do
        expect { call }.to(
          change { charge.reload.updated_at }
        )
      end
    end

    context 'when charge does not exist' do
      before do
        create(:user, stripe_customer_id: 'cus_00000000000000')
      end

      it 'creates charge' do
        expect { call }.to change(::SC::Billing::Stripe::Charge, :count).by(1)
      end
    end
  end
end
