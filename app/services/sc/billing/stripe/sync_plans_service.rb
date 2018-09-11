# frozen_string_literal: true

module SC::Billing::Stripe
  class SyncPlansService
    def call
      ::Stripe::Plan.all.data.each(&method(:create_or_actualize))
    end

    private

    def create_or_actualize(stripe_plan)
      plan = find_plan(stripe_plan.id)

      if plan.nil?
        create_plan(stripe_plan)
      else
        actualize_plan(plan, stripe_plan)
      end
    end

    def create_plan(stripe_plan)
      SC::Billing::Stripe::Plans::CreateOperation.new.call(stripe_plan)
    end

    def actualize_plan(plan, stripe_plan)
      SC::Billing::Stripe::Plans::UpdateOperation.new.call(plan, stripe_plan)
    end

    def find_plan(stripe_id)
      ::SC::Billing::Stripe::Plan.find(stripe_id: stripe_id)
    end
  end
end
