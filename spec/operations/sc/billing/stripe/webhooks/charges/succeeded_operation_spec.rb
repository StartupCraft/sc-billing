# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Charges::SucceededOperation, :stripe do
  let(:webhook_operation) { described_class.new }

  describe '#call' do
    subject(:call) do
      webhook_operation.call(event)
    end

    let(:event) { StripeMock.mock_webhook_event('charge.succeeded') }
    let(:event_data) { event.data.object }

    context 'when charge exists' do
      let!(:charge) { create(:stripe_charge, :pending, stripe_id: 'ch_00000000000000') }

      it 'updates charge' do
        expect { call }.to(
          change { charge.reload.status }.to('succeeded')
        )
      end
    end

    context 'when charge does not exist' do
      it 'creates charge' do
        expect { call }.to raise_error("There is no charge with stripe_id: #{event_data.id} in system")
      end
    end
  end
end
