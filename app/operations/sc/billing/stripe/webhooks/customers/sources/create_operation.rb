# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers::Sources
  class CreateOperation < SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'customer.source.created'

    def call(event)
      source_data = event.data.object
      return if payment_source_exists?(source_data.id)

      user = find_user(source_data.customer)
      return if user.nil?

      ::SC::Billing::Users::CreatePaymentSourceService.new(user).call(source_data)
    end

    private

    def find_user(customer_id)
      user_model.find(stripe_customer_id: customer_id)
    end

    def payment_source_exists?(source_id)
      !::SC::Billing::Stripe::PaymentSource.where(stripe_id: source_id).empty?
    end
  end
end
