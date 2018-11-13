# frozen_string_literal: true

Sequel.migration do
  change do
    create_table :stripe_invoices do
      primary_key :id

      foreign_key :user_id, SC::Billing.user_model.table_name, null: false, index: true
      foreign_key :subscription_id, :stripe_subscriptions, null: false, index: true

      String :stripe_id, null: false
      Jsonb :stripe_data, null: false

      Integer :total, null: false
      Integer :amount_due, null: false
      Integer :amount_paid, null: false
      String :currency, null: false

      DateTime :date, null: false
      DateTime :due_date

      FalseClass :forgiven, null: false
      FalseClass :closed, null: false
      FalseClass :attempted, null: false
      FalseClass :paid, null: false

      String :pdf_url

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      unique :stripe_id
    end
  end
end
