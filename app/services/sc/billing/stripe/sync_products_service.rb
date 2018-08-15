# frozen_string_literal: true

module SC::Billing::Stripe
  class SyncProductsService
    def call
      ::Stripe::Product.all.data.each(&method(:create_if_not_exists))
    end

    private

    def create_if_not_exists(stripe_product)
      return unless ::SC::Billing::Stripe::Product.where(stripe_id: stripe_product.id).empty?

      ::SC::Billing::Stripe::Product.create(stripe_id: stripe_product.id, name: stripe_product.name)
    end
  end
end
