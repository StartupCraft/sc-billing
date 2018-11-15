# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :stripe_invoice_items do
      primary_key :id

      foreign_key :invoice_id, :stripe_invoices, null: false, index: true
      foreign_key :plan_id, :stripe_plans, index: true

      String :stripe_id, null: false
      Jsonb :stripe_data, null: false

      Integer :amount, null: false
      String :currency, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
