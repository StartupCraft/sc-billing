# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks
  class BaseOperation < ::SC::Billing::BaseOperation
    def self.set_event_type(type_name)
      define_singleton_method(:event_type) do
        type_name
      end
    end
  end
end
