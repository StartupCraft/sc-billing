# frozen_string_literal: true

module SC::Billing::Stripe
  class Product < Sequel::Model(:stripe_products)
  end
end
