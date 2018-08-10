# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table SC::Billing.user_model.table_name do
      add_column :stripe_customer_id, String
      add_unique_constraint :stripe_customer_id
    end
  end
end
