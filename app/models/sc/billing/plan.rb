# frozen_string_literal: true

module SC::Billing
  class Plan < Sequel::Model
    many_to_one :product, class: 'SC::Billing::Product'
  end
end
