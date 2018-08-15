# frozen_string_literal: true

module Sequel::Plugins::ScBillingStripe
  def self.apply(model)
    model.instance_eval do
      many_to_one :default_payment_source,
                  key: :default_stripe_payment_source_id,
                  class_name: 'SC::Billing::Stripe::PaymentSource'
      one_to_many :payment_sources, class_name: 'SC::Billing::Stripe::PaymentSource'
      one_to_many :subscriptions, class_name: 'SC::Billing::Stripe::Subscription'
    end
  end
end
