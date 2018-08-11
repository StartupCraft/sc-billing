# frozen_string_literal: true

module SC::Billing::Users
  class CreatePaymentSourceService
    attr_accessor :user
    private       :user

    def initialize(user)
      @user = user
    end

    def call(stripe_data)
      send("create_#{stripe_data.object}", stripe_data)
    end

    private

    def create_card(card_data)
      create_payment_source(card_data)
    end

    def create_source(source_data)
      create_payment_source(source_data, status: source_data.status, type: source_data.type)
    end

    def create_payment_source(data, **extra_params)
      params = {
        object: data.object,
        stripe_id: data.id,
        user: user,
        stripe_data: data.as_json
      }

      ::SC::Billing::PaymentSource.create(params.merge(extra_params))
    end
  end
end
