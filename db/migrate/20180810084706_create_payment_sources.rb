# frozen_string_literal: true

Sequel.migration do
  up do
    extension :pg_enum

    create_enum(
      :payment_sources_statuses,
      %w[canceled chargeable consumed failed pending]
    )

    create_enum(
      :payment_sources_types,
      %w[
        ach_credit_transfer
        ach_debit
        alipay
        bancontact
        bitcoin
        card
        card_present
        eps
        giropay
        ideal
        multibanco
        p24
        sepa_credit_transfer
        sepa_debit
        sofort
        three_d_secure
      ]
    )

    create_enum(
      :payment_sources_objects, %w[source card]
    )

    create_table :payment_sources do
      primary_key :id

      String :stripe_id, null: false, unique: true
      payment_sources_objects :object, null: false
      payment_sources_types :type
      payment_sources_statuses :status
      Jsonb :stripe_data, null: false, default: '{}'

      foreign_key :user_id, :users, null: false, index: true

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  down do
    extension :pg_enum

    drop_table(:payment_sources)

    drop_enum(:payment_sources_statuses)
    drop_enum(:payment_sources_types)
    drop_enum(:payment_sources_objects)
  end
end
