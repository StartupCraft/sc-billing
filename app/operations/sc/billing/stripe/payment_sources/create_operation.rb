# frozen_string_literal: true

require 'dry/monads/try'

module SC::Billing::Stripe::PaymentSources
  class CreateOperation < ::SC::Billing::BaseOperation
    include Dry::Monads::Try::Mixin

    def call(user, token)
      Try(Stripe::InvalidRequestError, Stripe::CardError) do
        source = create_source_in_stripe(user, token)

        send("create_#{source.object}", user, source)
      end
    end

    private

    def create_source_in_stripe(user, token)
      customer = ::Stripe::Customer.retrieve(user.stripe_customer_id)
      customer.sources.create(source: token)
    end

    def create_card(user, card_data)
      create_payment_source(user, card_data)
    end

    def create_source(user, source_data)
      create_payment_source(user, source_data, status: source_data.status, type: source_data.type)
    end

    def create_payment_source(user, data, **extra_params)
      params = {
        object: data.object,
        stripe_id: data.id,
        user: user,
        stripe_data: data.as_json
      }

      ::SC::Billing::Stripe::PaymentSource.create(params.merge(extra_params))
    end
  end
end
