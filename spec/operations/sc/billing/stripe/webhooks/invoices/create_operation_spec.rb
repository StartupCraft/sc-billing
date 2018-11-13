# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Invoices::CreateOperation, :stripe do
  let(:webhook_operation) { described_class.new }

  describe '#call' do
    subject(:call) do
      webhook_operation.call(event)
    end

    let(:event) { StripeMock.mock_webhook_event('invoice.created') }
    let(:event_data) { event.data.object }

    let(:operation) { instance_double('::SC::Billing::Stripe::Invoices::CreateOperation') }

    before do
      allow(::SC::Billing::Stripe::Invoices::CreateOperation).to receive(:new).and_return(operation)
      allow(operation).to receive(:call)
      allow(webhook_operation).to receive(:run_after_hook)
    end

    context 'when all required exist' do
      let!(:user) { create(:user, stripe_customer_id: event_data.customer) }
      let!(:subscription) { create(:stripe_subscription, stripe_id: event_data.subscription) }

      it 'creates invoice', :aggregate_failures do
        call

        expect(operation).to have_received(:call).with(event_data, user: user, subscription: subscription)
        expect(webhook_operation).to have_received(:run_after_hook).with(hash_including(:invoice, :user))
      end
    end

    context 'when subscription does not exist' do
      before do
        create(:user, stripe_customer_id: event_data.customer)
      end

      it 'raises error' do
        expect { call }.to raise_error("There is no subscription with stripe_id: #{event_data.subscription} in system")
      end
    end

    context 'when user does not exist' do
      before do
        create(:stripe_subscription, stripe_id: event_data.subscription)
      end

      it 'raises error' do
        expect { call }.to raise_error("There is no user with stripe_customer_id: #{event_data.customer} in system")
      end
    end
  end
end
