# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table SC::Billing.user_model.table_name do
      add_foreign_key :default_stripe_payment_source_id, :stripe_payment_sources, index: true
    end
  end
end
