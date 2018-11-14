# frozen_string_literal: true

require 'sc/billing/helpers/from_timestamp_to_time'

module SC::Billing
  class Container
    extend Dry::Container::Mixin

    namespace 'helpers' do
      register('from_timestamp_to_time') { ::SC::Billing::Helpers::FromTimestampToTime.new }
    end

    namespace 'models' do
      namespace 'stripe' do
        register 'invoice' do
          ::SC::Billing::Stripe::Invoice
        end

        register 'subscription' do
          ::SC::Billing::Stripe::Subscription
        end
      end
    end
  end
end
