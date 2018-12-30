# frozen_string_literal: true

module SC::Billing::Stripe::Webhooks::Charges
  class PendingOperation < ::SC::Billing::Stripe::Webhooks::BaseOperation
    include ::SC::Billing::Import[charge_model: 'models.stripe.charge']

    set_event_type 'charge.pending'

    def call(event)
      charge_data = fetch_data(event)

      charge = find_charge(charge_data.id)

      if charge.nil?
        create_charge(charge_data)
      else
        actualize_charge(charge, charge_data)
      end
    end

    private

    def find_charge(stripe_id)
      charge_model.find(stripe_id: stripe_id)
    end

    def create_charge(charge_data)
      SC::Billing::Stripe::Charges::CreateOperation.new.call(charge_data)
    end

    def actualize_charge(charge, charge_data)
      SC::Billing::Stripe::Charges::UpdateOperation.new.call(charge, charge_data)
    end
  end
end
