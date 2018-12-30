# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Charges
  class FailedOperation < SC::Billing::Stripe::Webhooks::Charges::SucceededOperation
    set_event_type 'charge.failed'
  end
end
