# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Plans
  class UpdateOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    set_event_type 'plan.updated'

    def call(event)
      plan_data = fetch_data(event)
      plan = ::SC::Billing::Stripe::Plan.find(stripe_id: plan_data.id)
      return unless plan

      SC::Billing::Stripe::Plans::UpdateOperation.new.call(plan, plan_data)
    end
  end
end
