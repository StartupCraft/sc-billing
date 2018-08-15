class User < Sequel::Model
  plugin :sc_billing_stripe
end
