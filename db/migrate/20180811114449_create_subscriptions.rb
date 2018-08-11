# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum

    create_enum(
      :subscriptions_statuses,
      %w[trialing active past_due canceled unpaid]
    )

    create_table :subscriptions do
      primary_key :id

      foreign_key :user_id, :users, null: false, index: true

      subscriptions_statuses :status, null: false
      String :stripe_id, null: false

      DateTime :current_period_start_at, null: false
      DateTime :current_period_end_at, null: false
      DateTime :trial_start_at
      DateTime :trial_end_at
      Jsonb :stripe_data, null: false

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      unique :stripe_id
    end
  end
end
