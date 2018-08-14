# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::PaymentSources
  class DestroyOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(payment_source)
      Try(Stripe::InvalidRequestError) do
        detach_stripe_source(payment_source)
        payment_source.destroy
      end
    end

    private

    def detach_stripe_source(payment_source)
      customer = ::Stripe::Customer.retrieve(payment_source.user.stripe_customer_id)
      source = customer.sources.retrieve(payment_source.stripe_id)
      source.respond_to?(:delete) ? source.delete : source.detach
    end
  end
end
