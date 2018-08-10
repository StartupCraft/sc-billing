# frozen_string_literal: true

RSpec.describe SC::Billing::Webhooks::StripeAction do
  subject(:result) { action.call(request) }

  let(:action) { described_class.new }
  let(:request) { instance_double(ActionDispatch::Request, body: StringIO.new(body.to_s), env: {}) }
  let(:body) { {} }

  context 'when request is not correct' do
    it 'returns error' do
      expect(result).to be_failure
    end
  end

  describe 'events' do
    around do |example|
      StripeMock.start

      example.run

      StripeMock.stop
    end

    before do
      allow(::Stripe::Webhook).to receive(:construct_event).with(any_args).and_return(event)
    end

    context 'when handler configured outside of gem' do
      let(:event) { StripeMock.mock_webhook_event('customer.created') }
      let(:operation) { instance_double(::Customers::CreateOperation) }

      before do
        allow(::Customers::CreateOperation).to receive(:new).and_return(operation)
        allow(operation).to receive(:call)
      end

      around do |example|
        SC::Billing.configure do |config|
          config.custom_event_handlers = {
            'customer.created' => ::Customers::CreateOperation
          }
        end

        example.run

        SC::Billing.configure do |config|
          config.custom_event_handlers = {}
        end
      end

      it 'execute proper operation', :aggregate_failures do
        expect(result).to be_success
        expect(operation).to have_received(:call).with(event)
      end
    end

    context 'when event in list of available events' do
      let(:event) { StripeMock.mock_webhook_event('customer.created') }
      let(:operation) { instance_double(::SC::Billing::Stripe::Customers::CreateOperation) }

      before do
        allow(::SC::Billing::Stripe::Customers::CreateOperation).to receive(:new).and_return(operation)
        allow(operation).to receive(:call)
      end

      around do |example|
        ::SC::Billing.configure do |config|
          initial_list = ::SC::Billing.available_events

          config.available_events = ['customer.created']

          example.run

          config.available_events = initial_list
        end
      end

      it 'execute proper operation', :aggregate_failures do
        expect(result).to be_success
        expect(operation).to have_received(:call).with(event)
      end
    end

    context 'when event not in list of available events' do
      let(:event) { StripeMock.mock_webhook_event('customer.created') }
      let(:operation) { instance_double(::SC::Billing::Stripe::Customers::CreateOperation) }

      before do
        allow(::SC::Billing::Stripe::Customers::CreateOperation).to receive(:new).and_return(operation)
        allow(operation).to receive(:call)
      end

      around do |example|
        ::SC::Billing.configure do |config|
          initial_list = ::SC::Billing.available_events

          config.available_events = []

          example.run

          config.available_events = initial_list
        end
      end

      it 'returns failure', :aggregate_failures do
        expect(result).to be_failure
        expect(operation).not_to have_received(:call).with(event)
      end
    end

    context 'when event is customer.created' do
      let(:event) { StripeMock.mock_webhook_event('customer.created') }
      let(:operation) { instance_double(::SC::Billing::Stripe::Customers::CreateOperation) }

      before do
        allow(::SC::Billing::Stripe::Customers::CreateOperation).to receive(:new).and_return(operation)
        allow(operation).to receive(:call)
      end

      it 'execute proper operation', :aggregate_failures do
        expect(result).to be_success
        expect(operation).to have_received(:call).with(event)
      end
    end
  end
end
