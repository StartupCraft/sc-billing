# frozen_string_literal: true

module SC::Billing::Stripe::Plans
  class UpdateOperation < ::SC::Billing::BaseOperation
    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        nickname
        amount
        currency
        interval
        interval_count
        trial_period_days
      ]

      rename_keys nickname: :name
    end

    def call(plan, plan_data)
      Transformer.new.call(plan_data).yield_self do |plan_params|
        plan.update(plan_params)
      end
    end
  end
end
