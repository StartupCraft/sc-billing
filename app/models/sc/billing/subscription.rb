# frozen_string_literal: true

module SC::Billing
  class Subscription < Sequel::Model
    plugin :association_pks
    plugin :many_through_many

    many_to_one :user, class: SC::Billing.user_model
    many_to_many :plans, class: 'SC::Billing::Plan', join_table: :subscribed_plans, delay_pks: :always
    many_through_many :products,
                      [
                        %i[subscribed_plans subscription_id plan_id],
                        %i[plans id product_id]
                      ],
                      class: 'SC::Billing::Product'
  end
end
