# frozen_string_literal: true

Sequel.migration do
  up do
    run(<<-SQL.squish)
      CREATE EXTENSION IF NOT EXISTS citext;
    SQL

    create_table :users do
      primary_key :id

      Citext :email, null: false, unique: true

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
