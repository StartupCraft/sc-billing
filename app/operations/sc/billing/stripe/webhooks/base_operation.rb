# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks
  class BaseOperation < ::SC::Billing::BaseOperation
    def self.set_event_type(type_name)
      define_singleton_method(:event_type) do
        type_name
      end
    end

    private

    def run_hook(hook_type, *params)
      hook_handler = ::SC::Billing.event_hooks.dig(self.class.event_type, hook_type)
      return if hook_handler.nil?

      hook_handler.new.call(*params)
    end

    def run_before_hook(*params)
      run_hook(:before, *params)
    end

    def run_after_hook(*params)
      run_hook(:after, *params)
    end
  end
end
