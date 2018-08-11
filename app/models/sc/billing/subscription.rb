# frozen_string_literal: true

module SC::Billing
  class Subscription < Sequel::Model
    plugin :association_pks

    many_to_one :user, class: SC::Billing.user_model
    many_to_many :plans, class: 'SC::Billing::Plan', join_table: :subscribed_plans, delay_pks: :always
  end
end
