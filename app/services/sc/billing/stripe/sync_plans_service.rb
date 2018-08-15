# frozen_string_literal: true

module SC::Billing::Stripe
  class SyncPlansService
    def call
      ::Stripe::Plan.all.data.each(&method(:create_if_not_exists))
    end

    private

    def create_if_not_exists(stripe_plan)
      return if plan_exists?(stripe_plan.id)

      product = find_product(stripe_plan.product)
      raise "There is no product with id: #{stripe_plan.product} in system" unless product

      ::SC::Billing::Stripe::Plan.create(
        stripe_id: stripe_plan.id,
        name: stripe_plan.nickname,
        product: product,
        amount: stripe_plan.amount,
        currency: stripe_plan.currency
      )
    end

    def plan_exists?(stripe_id)
      !::SC::Billing::Stripe::Plan.where(stripe_id: stripe_id).empty?
    end

    def find_product(product_id)
      ::SC::Billing::Stripe::Product.find(stripe_id: product_id)
    end
  end
end
