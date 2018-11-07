# frozen_string_literal: true

module SC::Billing::Stripe::Plans
  class CreateOperation < ::SC::Billing::BaseOperation
    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        id
        nickname
        amount
        currency
        interval
        interval_count
        trial_period_days
      ]

      rename_keys id: :stripe_id, nickname: :name
    end

    def call(event)
      plan_data = fetch_data(event)
      return if plan_exists?(plan_data)

      product = ::SC::Billing::Stripe::Product.find(stripe_id: plan_data.product)
      raise "There is no product with id: #{plan_data.product} in system" unless product

      create_plan(product, plan_data)
    end

    private

    def create_plan(product, plan_data)
      Transformer.new.call(plan_data).yield_self do |plan_params|
        plan_params[:product] = product
        plan_params[:applicable] = false

        ::SC::Billing::Stripe::Plan.create(plan_params)
      end
    end

    def plan_exists?(plan_data)
      !::SC::Billing::Stripe::Plan.where(stripe_id: plan_data.id).empty?
    end
  end
end
