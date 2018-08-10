# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :products do
      primary_key :id

      String :name, null: false
      String :stripe_id, null: false

      unique :stripe_id
      unique :name
    end
  end
end
