# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers
  class UpdateOperation < ::SC::Billing::BaseOperation
    def call(event)
      customer_data = event.respond_to?(:data) ? event.data.object : event
      user = find_user(customer_data.id)
      return if user.nil?

      actualize_default_payment_source(user, customer_data.default_source)
    end

    private

    def find_user(customer_id)
      user_model.find(stripe_customer_id: customer_id)
    end

    def actualize_default_payment_source(user, source_id)
      return user.update(default_payment_source: nil) if source_id.nil?

      attach_default_payment_source(user, source_id)
    end

    def attach_default_payment_source(user, source_id)
      payment_source = ::SC::Billing::PaymentSource.find(stripe_id: source_id)
      return if payment_source.nil?

      user.update(default_payment_source: payment_source)
    end
  end
end
