# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :stripe_subscribed_plans do
      primary_key :id

      foreign_key :subscription_id, :stripe_subscriptions, null: false, index: true
      foreign_key :plan_id, :stripe_plans, null: false, index: true

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      unique %i[subscription_id plan_id]
    end
  end
end
