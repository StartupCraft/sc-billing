# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::BaseOperation do
  let(:operation_class) do
    Class.new(described_class) do
      set_event_type 'event.type'

      def call
        run_before_hook

        # do something

        run_after_hook
      end
    end
  end
  let(:operation) { operation_class.new }

  describe '.set_event_type' do
    it { expect(operation_class.event_type).to eq('event.type') }
  end

  describe '#before hook' do
    let(:before_hook_operation_class) do
      Class.new do
        def call; end
      end
    end
    let(:before_hook_operation) do
      before_hook_operation_class.new
    end

    before do
      allow(before_hook_operation_class).to receive(:new).and_return(before_hook_operation)
      allow(before_hook_operation).to receive(:call)
    end

    context 'when hook activated' do
      around do |example|
        ::SC::Billing.configure do |config|
          initial_available_events = ::SC::Billing.available_events
          initial_event_hooks = ::SC::Billing.event_hooks

          config.available_events = ['event.type']
          config.event_hooks = {
            'event.type' => {before: before_hook_operation_class}
          }

          example.run

          config.available_events = initial_available_events
          config.event_hooks = initial_event_hooks
        end
      end

      it 'calls before hook' do
        operation.call

        expect(before_hook_operation).to have_received(:call)
      end
    end

    context 'when hook not activated' do
      it 'does not call before hook' do
        operation.call

        expect(before_hook_operation).to_not have_received(:call)
      end
    end
  end

  describe '#after hook' do
    let(:after_hook_operation_class) do
      Class.new do
        def call; end
      end
    end
    let(:after_hook_operation) do
      after_hook_operation_class.new
    end

    before do
      allow(after_hook_operation_class).to receive(:new).and_return(after_hook_operation)
      allow(after_hook_operation).to receive(:call)
    end

    context 'when hook activated' do
      around do |example|
        ::SC::Billing.configure do |config|
          initial_available_events = ::SC::Billing.available_events
          initial_event_hooks = ::SC::Billing.event_hooks

          config.available_events = ['event.type']
          config.event_hooks = {
            'event.type' => {after: after_hook_operation_class}
          }

          example.run

          config.available_events = initial_available_events
          config.event_hooks = initial_event_hooks
        end
      end

      it 'calls after hook' do
        operation.call

        expect(after_hook_operation).to have_received(:call)
      end
    end

    context 'when hook not activated' do
      it 'does not call after hook' do
        operation.call

        expect(after_hook_operation).to_not have_received(:call)
      end
    end
  end
end
