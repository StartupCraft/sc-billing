# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Plans
  class UpdateOperation < ::SC::Billing::BaseOperation
    def call(event)
      plan_data = event.data.object
      plan = ::SC::Billing::Stripe::Plan.find(stripe_id: plan_data.id)
      return unless plan

      SC::Billing::Stripe::Plans::UpdateOperation.new.call(plan, plan_data)
    end
  end
end
