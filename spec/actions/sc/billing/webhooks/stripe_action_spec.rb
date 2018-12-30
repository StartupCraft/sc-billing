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
    shared_examples_for 'executes proper operation by webhook' do |event_name:, operation_class:|
      let(:event) { StripeMock.mock_webhook_event(event_name) }
      let(:operation) { instance_double(operation_class) }

      before do
        allow(operation_class).to(
          receive(:new).and_return(operation)
        )
        allow(operation).to receive(:call)
      end

      it 'execute proper operation', :aggregate_failures do
        expect(result).to be_success
        expect(operation).to have_received(:call).with(event)
      end
    end

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
      let(:operation) { instance_double(::SC::Billing::Stripe::Webhooks::Customers::CreateOperation) }

      before do
        allow(::SC::Billing::Stripe::Webhooks::Customers::CreateOperation).to receive(:new).and_return(operation)
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
      let(:operation) { instance_double(::SC::Billing::Stripe::Webhooks::Customers::CreateOperation) }

      before do
        allow(::SC::Billing::Stripe::Webhooks::Customers::CreateOperation).to receive(:new).and_return(operation)
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
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.created',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::CreateOperation
      )
    end

    context 'when event is customer.updated' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.updated',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::UpdateOperation
      )
    end

    context 'when event is product.created' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'product.created',
        operation_class: ::SC::Billing::Stripe::Webhooks::Products::CreateOperation
      )
    end

    context 'when event is plan.created' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'plan.created',
        operation_class: ::SC::Billing::Stripe::Webhooks::Plans::CreateOperation
      )
    end

    context 'when event is plan.updated' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'plan.updated',
        operation_class: ::SC::Billing::Stripe::Webhooks::Plans::UpdateOperation
      )
    end

    context 'when event is customer.source.created' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.source.created',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::Sources::CreateOperation
      )
    end

    context 'when event is customer.source.updated' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.source.updated',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::Sources::UpdateOperation
      )
    end

    context 'when event is customer.source.deleted' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.source.deleted',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::Sources::DeleteOperation
      )
    end

    context 'when event is customer.subscription.created' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.subscription.created',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::Subscriptions::CreateOperation
      )
    end

    context 'when event is customer.subscription.updated' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.subscription.updated',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::Subscriptions::UpdateOperation
      )
    end

    context 'when event is customer.subscription.deleted' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'customer.subscription.deleted',
        operation_class: ::SC::Billing::Stripe::Webhooks::Customers::Subscriptions::DeleteOperation
      )
    end

    context 'when event is invoice.created' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'invoice.created',
        operation_class: ::SC::Billing::Stripe::Webhooks::Invoices::CreateOperation
      )
    end

    context 'when event is invoice.updated' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'invoice.updated',
        operation_class: ::SC::Billing::Stripe::Webhooks::Invoices::UpdateOperation
      )
    end

    context 'when event is invoice.payment_succeeded' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'invoice.payment_succeeded',
        operation_class: ::SC::Billing::Stripe::Webhooks::Invoices::PaymentSucceededOperation
      )
    end

    context 'when event is charge.pending' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'charge.pending',
        operation_class: ::SC::Billing::Stripe::Webhooks::Charges::PendingOperation
      )
    end

    context 'when event is charge.succeeded' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'charge.succeeded',
        operation_class: ::SC::Billing::Stripe::Webhooks::Charges::SucceededOperation
      )
    end

    context 'when event is charge.failed' do
      it_behaves_like(
        'executes proper operation by webhook',
        event_name: 'charge.failed',
        operation_class: ::SC::Billing::Stripe::Webhooks::Charges::FailedOperation
      )
    end
  end
end
