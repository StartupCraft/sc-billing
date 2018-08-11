# frozen_string_literal: true

module SC::Billing::Subscriptions
  class CreateOperation < ::SC::Billing::BaseOperation
    include ::SC::Billing::Import['helpers.from_timestamp_to_time']

    def call(data, **extra_params)
      ::SC::Billing::Subscription.create(subscription_params(data, extra_params))
    end

    private

    def subscription_params(data, extra_params)
      params_by_subscription_data(data).merge!(extra_params)
    end

    def params_by_subscription_data(data)
      {
        status: data.status,
        current_period_start_at: from_timestamp_to_time.call(data.current_period_start),
        current_period_end_at: from_timestamp_to_time.call(data.current_period_end),
        trial_start_at: from_timestamp_to_time.call(data.trial_start),
        trial_end_at: from_timestamp_to_time.call(data.trial_end),
        stripe_data: data.as_json
      }
    end
  end
end
