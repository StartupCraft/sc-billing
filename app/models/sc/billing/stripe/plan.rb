# frozen_string_literal: true

module SC::Billing::Stripe
  class Plan < Sequel::Model(:stripe_plans)
    many_to_one :product, class_name: 'SC::Billing::Stripe::Product'

    dataset_module do
      def applicable
        where(applicable: true)
      end
    end

    def free?
      amount.zero?
    end

    def paid?
      !free?
    end
  end
end
