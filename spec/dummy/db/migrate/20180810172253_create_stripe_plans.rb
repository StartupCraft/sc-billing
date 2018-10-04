# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :stripe_plans do
      primary_key :id

      String :name, null: false
      String :stripe_id, null: false
      Integer :amount, null: false
      String :currency, null: false
      foreign_key :product_id, :stripe_products, null: false, index: true
      String :interval, null: false
      Integer :interval_count, null: false
      Integer :trial_period_days
      FalseClass :applicable, null: false

      unique :stripe_id

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
