# frozen_string_literal: true

module SC::Billing
  class SubscribedPlan < Sequel::Model
    many_to_one :subscription, class: 'SC::Billing::Subscription'
    many_to_one :plan, class: 'SC::Billing::Plan'
  end
end
