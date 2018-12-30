# frozen_string_literal: true

module SC::Billing::Stripe::Charges
  class CreateOperation < ::SC::Billing::BaseOperation
    include SC::Billing::FindOrRaise[
      user: :stripe_customer_id
    ]

    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        id
        status
        paid
        refunded
      ]

      rename_keys id: :stripe_id
    end

    def call(charge_data)
      create_charge(charge_data)
    end

    private

    def create_charge(charge_data)
      user = find_or_raise_user(charge_data.customer)

      Transformer.new.call(charge_data).yield_self do |charge_params|
        charge_params[:user] = user
        charge_params[:stripe_data] = charge_data.as_json

        ::SC::Billing::Stripe::Charge.create(charge_params)
      end
    end
  end
end
