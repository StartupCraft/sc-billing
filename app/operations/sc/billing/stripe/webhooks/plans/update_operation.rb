# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Plans
  class UpdateOperation < ::SC::Billing::BaseOperation
    def call(event)
      plan_data = event.data.object
      plan = ::SC::Billing::Stripe::Plan.find(stripe_id: plan_data.id)
      return unless plan

      plan.update(
        name: plan_data.nickname,
        amount: plan_data.amount,
        currency: plan_data.currency
      )
    end
  end
end
