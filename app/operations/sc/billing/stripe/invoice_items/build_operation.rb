# frozen_string_literal: true

module SC::Billing::Stripe::InvoiceItems
  class BuildOperation < ::SC::Billing::BaseOperation
    include ::SC::Billing::Import[
      plan_model: 'models.stripe.plan'
    ]

    class Transformer < Transproc::Transformer[SC::Billing::Transform]
      attrs_to_hash %i[
        id
        amount
        currency
      ]

      rename_keys id: :stripe_id
    end

    def call(item_data)
      build_item(item_data)
    end

    private

    def build_item(item_data)
      Transformer.new.call(item_data).tap do |item_params|
        item_params[:stripe_data] = item_data.as_json
        item_params[:plan_id] = plan_model.where(stripe_id: item_data.plan.id).get(:id) if item_data.plan.present?
      end
    end
  end
end
