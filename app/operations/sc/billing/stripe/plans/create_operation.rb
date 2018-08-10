# frozen_string_literal: true

module SC::Billing::Stripe::Plans
  class CreateOperation < ::SC::Billing::BaseOperation
    def call(event)
      plan_data = event.data.object
      return if plan_exists?(plan_data)

      product = ::SC::Billing::Product.find(stripe_id: plan_data.product)
      raise "There is no product with id: #{plan_data.product} in system" unless product

      create_plan(product, plan_data)
    end

    private

    def create_plan(product, plan_data)
      ::SC::Billing::Plan.create(
        product: product,
        stripe_id: plan_data.id,
        name: plan_data.nickname,
        amount: plan_data.amount,
        currency: plan_data.currency
      )
    end

    def plan_exists?(plan_data)
      !::SC::Billing::Plan.where(stripe_id: plan_data.id).empty?
    end
  end
end
