# frozen_string_literal: true

module SC::Billing::Stripe
  class Charge < Sequel::Model(:stripe_charges)
    PENDING_STATUS = 'pending'
    SUCCEEDED_STATUS = 'succeeded'
    FAILED_STATUS = 'failed'

    STATUSES = [
      PENDING_STATUS,
      SUCCEEDED_STATUS,
      FAILED_STATUS
    ].freeze

    many_to_one :user, class_name: SC::Billing.user_model
  end
end
