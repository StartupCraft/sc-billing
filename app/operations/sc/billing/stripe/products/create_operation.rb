# frozen_string_literal: true

module SC::Billing::Stripe::Products
  class CreateOperation < ::SC::Billing::BaseOperation
    def call(event)
      product_data = event.data.object
      return if product_exists?(product_data)

      ::SC::Billing::Product.create(
        stripe_id: product_data.id,
        name: product_data.name
      )
    end

    private

    def product_exists?(product_data)
      !::SC::Billing::Product.where(stripe_id: product_data.id).empty?
    end
  end
end
