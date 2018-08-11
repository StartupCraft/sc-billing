# frozen_string_literal: true

module SC::Billing::Stripe::Customers::Sources
  class UpdateOperation < ::SC::Billing::BaseOperation
    def call(event)
      source_data = event.data.object
      payment_source = find_payment_source(source_data.id)
      return if payment_source.nil?

      update_payment_source(payment_source, source_data)
    end

    private

    def find_payment_source(source_id)
      ::SC::Billing::PaymentSource.find(stripe_id: source_id)
    end

    def update_payment_source(payment_source, source_data)
      send("update_#{source_data.object}", payment_source, source_data)
    end

    def update_card(payment_source, source_data)
      payment_source.update(stripe_data: source_data.as_json)
    end

    def update_source(payment_source, source_data)
      payment_source.update(
        type: source_data.type,
        status: source_data.status,
        stripe_data: source_data.as_json
      )
    end
  end
end
