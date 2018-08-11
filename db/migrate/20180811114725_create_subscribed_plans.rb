# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :subscribed_plans do
      primary_key :id

      foreign_key :subscription_id, :subscriptions, null: false, index: true
      foreign_key :plan_id, :plans, null: false, index: true

      unique %i[subscription_id plan_id]
    end
  end
end
