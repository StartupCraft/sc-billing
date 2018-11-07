# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers::Sources
  class DeleteOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'customer.source.deleted'

    def call(event)
      source_data = fetch_data(event)
      payment_source = find_payment_source(source_data.id)
      return if payment_source.nil?

      delete_payment_source(payment_source)
    end

    private

    def find_payment_source(source_id)
      ::SC::Billing::Stripe::PaymentSource.find(stripe_id: source_id)
    end

    def delete_payment_source(payment_source)
      user = payment_source.user

      ::SC::Billing::Stripe::PaymentSource.db.transaction do
        user.update(default_payment_source: nil) if payment_source_is_default?(user, payment_source)
        payment_source.destroy
      end
    end

    def payment_source_is_default?(user, payment_source)
      user.default_stripe_payment_source_id == payment_source.id
    end
  end
end
