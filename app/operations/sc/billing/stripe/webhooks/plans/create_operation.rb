# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Plans
  class CreateOperation < ::SC::Billing::BaseOperation
    def call(event)
      ::SC::Billing::Stripe::Plans::CreateOperation.new.call(event)
    end
  end
end
