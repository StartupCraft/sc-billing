# frozen_string_literal: true

module SC::Billing::Stripe::Customers
  class CreateOperation < ::SC::Billing::BaseOperation
    def call(event)
      customer_data = event.data.object
      user = find_user(customer_data)

      user ? actualize_user(user, customer_data) : create_user(customer_data)
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
