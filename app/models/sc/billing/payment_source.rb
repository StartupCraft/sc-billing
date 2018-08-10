# frozen_string_literal: true

module SC::Billing
  class PaymentSource < Sequel::Model
    many_to_one :user, class: ::SC::Billing.user_model_name
  end
end
