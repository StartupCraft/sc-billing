# frozen_string_literal: true

module SC::Billing::Stripe::Charges
  class UpdateOperation < ::SC::Billing::BaseOperation
    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        status
        paid
        refunded
        failure_code
        failure_message
      ]
    end

    def call(charge, charge_data)
      update_charge(charge, charge_data)
    end

    private

    def update_charge(charge, charge_data)
      Transformer.new.call(charge_data).yield_self do |charge_params|
        charge_params[:stripe_data] = charge_data.as_json
        charge.update(charge_params)
      end
    end
  end
end
