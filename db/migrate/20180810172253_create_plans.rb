# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :plans do
      primary_key :id

      String :name, null: false
      String :stripe_id, null: false
      Integer :amount, null: false
      String :currency, null: false
      foreign_key :product_id, :products, null: false, index: true

      unique :stripe_id
    end
  end
end
