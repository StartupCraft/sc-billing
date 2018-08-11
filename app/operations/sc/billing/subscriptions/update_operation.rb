# frozen_string_literal: true

module SC::Billing::Subscriptions
  class UpdateOperation < CreateOperation
    attr_accessor :subscription
    private       :subscription

    def initialize(subscription:, **args)
      self.subscription = subscription

      super(args)
    end

    def call(data, **extra_params)
      subscription.update(subscription_params(data, extra_params))
    end
  end
end
