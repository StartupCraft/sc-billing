# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Charges
  class SucceededOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    include ::SC::Billing::Import[charge_model: 'models.stripe.charge']
    include SC::Billing::FindOrRaise[charge: :stripe_id]

    set_event_type 'charge.succeeded'

    def call(event)
      charge_data = fetch_data(event)

      charge = find_or_raise_charge(charge_data.id)
      actualize_charge(charge, charge_data)
    end

    private

    def actualize_charge(charge, charge_data)
      SC::Billing::Stripe::Charges::UpdateOperation.new.call(charge, charge_data)
    end
  end
end
