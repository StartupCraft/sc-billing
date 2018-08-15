# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::PaymentSources
  class MakeDefaultOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(payment_source)
      Try(Stripe::InvalidRequestError) do
        make_default_in_stripe(payment_source)
        make_default_in_db(payment_source)
      end
    end

    private

    def make_default_in_stripe(payment_source)
      customer_stripe_id = payment_source.user.stripe_customer_id

      ::Stripe::Customer.retrieve(customer_stripe_id).tap do |stripe_customer|
        stripe_customer.default_source = payment_source.stripe_id
        stripe_customer.save
      end
    end

    def make_default_in_db(payment_source)
      payment_source.user.update(default_payment_source: payment_source)
    end
  end
end
