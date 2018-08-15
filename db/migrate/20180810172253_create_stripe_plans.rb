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

      unique :stripe_id

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
