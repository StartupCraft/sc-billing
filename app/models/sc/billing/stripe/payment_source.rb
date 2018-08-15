# frozen_string_literal: true

module SC::Billing::Stripe
  class PaymentSource < Sequel::Model(:stripe_payment_sources)
    many_to_one :user, class_name: ::SC::Billing.user_model_name
  end
end
