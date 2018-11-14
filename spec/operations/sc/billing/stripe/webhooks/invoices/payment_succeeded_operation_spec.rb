# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Invoices::PaymentSucceededOperation, :stripe do
  let(:webhook_operation) { described_class.new }

  describe '#call' do
    subject(:call) do
      webhook_operation.call(event)
    end

    let(:event) { StripeMock.mock_webhook_event('invoice.payment_succeeded') }
    let(:event_data) { event.data.object }

    let(:operation) { instance_double('::SC::Billing::Stripe::Invoices::UpdateOperation') }

    before do
      allow(::SC::Billing::Stripe::Invoices::UpdateOperation).to receive(:new).and_return(operation)
      allow(operation).to receive(:call)
      allow(webhook_operation).to receive(:run_after_hook)
    end

    context 'when invoice exists' do
      let!(:invoice) { create(:stripe_invoice, stripe_id: event_data.id) }

      it 'updates invoice', :aggregate_failures do
        call

        expect(operation).to have_received(:call).with(invoice, event_data)
        expect(webhook_operation).to have_received(:run_after_hook).with(hash_including(:invoice))
      end
    end

    context 'when invoice does not exist' do
      it 'raises error' do
        expect { call }.to raise_error("There is no invoice with stripe_id: #{event_data.id} in system")
      end
    end
  end
end
