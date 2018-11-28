# frozen_string_literal: true

Sequel.migration do
  no_transaction

  up do
    extension :pg_enum

    add_enum_value(SC::Billing.registration_source.enum_name, 'stripe')
  end
end
