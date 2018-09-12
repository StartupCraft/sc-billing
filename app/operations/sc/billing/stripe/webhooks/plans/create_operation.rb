# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Plans
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'plan.created'

    def call(event)
      ::SC::Billing::Stripe::Plans::CreateOperation.new.call(event)
    end
  end
end
