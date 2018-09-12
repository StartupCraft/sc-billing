# frozen_string_literal: true

module SC::Billing::Stripe
  class Subscription < Sequel::Model(:stripe_subscriptions)
    plugin :association_pks
    plugin :many_through_many

    TRIAL_STATUS = 'trialing'
    ACTIVE_STATUS = 'active'
    PAST_DUE_STATUS = 'past_due'
    CANCELED_STATUS = 'canceled'
    UNPAID_STATUS = 'unpaid'
    STATUSES = [
      TRIAL_STATUS,
      ACTIVE_STATUS,
      PAST_DUE_STATUS,
      CANCELED_STATUS,
      UNPAID_STATUS
    ].freeze

    many_to_one :user, class_name: SC::Billing.user_model
    many_to_many :plans,
                 class_name: 'SC::Billing::Stripe::Plan',
                 join_table: :stripe_subscribed_plans,
                 delay_pks: :always

    many_through_many :products,
                      [
                        %i[stripe_subscribed_plans subscription_id plan_id],
                        %i[stripe_plans id product_id]
                      ],
                      class_name: 'SC::Billing::Stripe::Product'

    STATUSES.each do |status|
      define_method("#{status}?") do
        self.status == status
      end
    end
  end
end
