# frozen_string_literal: true

module Sequel::Plugins::ScBilling
  def self.apply(model)
    model.instance_eval do
      many_to_one :default_payment_source, class_name: 'SC::Billing::PaymentSource'
    end
  end
end
