# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum

    create_enum(
      SC::Billing.registration_source.enum_name,
      %w[]
    )

    alter_table SC::Billing.user_model.table_name do
      add_column SC::Billing.registration_source.field_name, SC::Billing.registration_source.enum_name
    end
  end

  down do
    extension :pg_enum

    alter_table SC::Billing.user_model.table_name do
      drop_enum SC::Billing.registration_source.enum_name
      drop_column SC::Billing.registration_source.field_name
    end
  end
end
