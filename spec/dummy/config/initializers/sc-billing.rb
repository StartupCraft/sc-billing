SC::Billing.configure do |config|
  config.user_model_name = 'User'
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
    'invoice.updated'
  ]
end
