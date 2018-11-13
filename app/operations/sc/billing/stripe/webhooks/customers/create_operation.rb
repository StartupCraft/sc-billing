# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Customers
  class CreateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'customer.created'

    def call(event)
      customer_data = fetch_data(event)
      user = find_user_by_email(customer_data.email)

      user = user ? actualize_user(user, customer_data) : create_user(customer_data)

      run_after_hook(event: event, user: user)
    end

    private

    def actualize_user(user, customer_data)
      user.set(stripe_customer_id: customer_data.id).save
    end

    def create_user(customer_data)
      user_model.create(
        stripe_customer_id: customer_data.id,
        email: customer_data.email
      )
    end

    def find_user_by_email(email)
      user_model.find(email: email)
    end
  end
end
