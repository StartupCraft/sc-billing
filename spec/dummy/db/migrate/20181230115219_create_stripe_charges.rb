# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum

    create_enum(
      :stripe_charges_statuses,
      %w[pending succeeded failed]
    )

    create_table :stripe_charges do
      primary_key :id

      foreign_key :user_id, SC::Billing.user_model.table_name, null: false, index: true

      String :stripe_id, null: false
      Jsonb :stripe_data, null: false

      column :status, :stripe_charges_statuses, null: false

      FalseClass :paid, null: false
      FalseClass :refunded, null: false

      String :failure_code
      String :failure_message

      String :additional_attr

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      unique :stripe_id
    end
  end

  down do
    extension :pg_enum

    drop_table :stripe_charges
    drop_enum :stripe_charges_statuses
  end
end
