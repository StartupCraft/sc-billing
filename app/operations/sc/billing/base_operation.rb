# frozen_string_literal: true

require 'dry/transaction/operation'

module SC::Billing
  class BaseOperation
    include Dry::Transaction::Operation

    delegate :user_model, to: :'SC::Billing'
  end
end
