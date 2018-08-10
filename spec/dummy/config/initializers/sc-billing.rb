SC::Billing.configure do |config|
  config.user_model_name = 'User'
  config.available_events = [
    'customer.created',
    'customer.updated'
  ]
end
