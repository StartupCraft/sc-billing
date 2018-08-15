# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Plans::UpdateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('plan.updated') }
  let(:plan_data) { event.data.object }

  let!(:plan) { create(:stripe_plan, stripe_id: plan_data.id) }

  it 'updates plan' do
    expect { call }.to(
      change { plan.reload.name }.to(plan_data.nickname)
        .and(change { plan.reload.amount }.to(2700))
        .and(change { plan.reload.currency }.to('cad'))
    )
  end
end
