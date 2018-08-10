# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    to_create(&:save)

    email { FFaker::Internet.email }
  end
end
