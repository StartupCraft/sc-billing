# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::Customers
  class CreateOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(user, token:)
      Try(Stripe::InvalidRequestError) do
        stripe_data = create_in_stripe(user, token)
        actualize_user(user, stripe_data)
      end
    end

    private

    def create_in_stripe(user, token)
      ::Stripe::Customer.create(email: user.email, source: token)
    end

    def actualize_user(user, stripe_data)
      user.update(stripe_customer_id: stripe_data.id)
    end
  end
end
