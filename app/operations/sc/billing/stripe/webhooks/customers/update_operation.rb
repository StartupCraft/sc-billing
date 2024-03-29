# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers
  class UpdateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'customer.updated'

    def call(event)
      customer_data = fetch_data(event)
      user = find_user(customer_data.id)
      return if user.nil?

      actualize_default_payment_source(user, customer_data.default_source)
    end

    private

    def actualize_default_payment_source(user, source_id)
      return user.update(default_payment_source: nil) if source_id.nil?

      attach_default_payment_source(user, source_id)
    end

    def attach_default_payment_source(user, source_id)
      payment_source = ::SC::Billing::Stripe::PaymentSource.find(stripe_id: source_id)
      return if payment_source.nil?

      user.update(default_payment_source: payment_source)
    end
  end
end
