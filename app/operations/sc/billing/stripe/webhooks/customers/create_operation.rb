# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'customer.created'

    def call(event)
      customer_data = event.data.object
      user = find_user(customer_data)

      user = user ? actualize_user(user, customer_data) : create_user(customer_data)

      run_after_hook(event: event, user: user)
    end

    private

    def find_user(customer_data)
      user_model.find(email: customer_data.email)
    end

    def actualize_user(user, customer_data)
      user.set(stripe_customer_id: customer_data.id).save
    end

    def create_user(customer_data)
      user_model.create(
        stripe_customer_id: customer_data.id,
        email: customer_data.email
      )
    end
  end
end
