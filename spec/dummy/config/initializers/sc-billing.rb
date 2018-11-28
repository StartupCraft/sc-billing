SC::Billing.configure do |config|
  config.user_model_name = 'User'

  config.registration_source[:follow?] = true
  config.registration_source.enum_name = :users_created_in_types
  config.registration_source.field_name = :created_in

  config.available_events = [
    'customer.created',
    'customer.updated',
    'product.created',
    'plan.created',
    'plan.updated',
    'customer.source.created',
    'customer.source.updated',
    'customer.source.deleted',
    'customer.subscription.created',
    'customer.subscription.updated',
    'customer.subscription.deleted',
    'invoice.created',
    'invoice.updated',
    'invoice.payment_succeeded'
  ]
end
