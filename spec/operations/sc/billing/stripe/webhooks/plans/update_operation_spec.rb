# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Webhooks::Plans::UpdateOperation, :stripe do
  subject(:call) do
    described_class.new.call(event)
  end

  let(:event) { StripeMock.mock_webhook_event('plan.updated') }
  let(:plan_data) { event.data.object }

  let!(:plan) { create(:stripe_plan, stripe_id: plan_data.id, interval: 'day', interval_count: 7) }

  it 'updates plan' do
    expect { call }.to(
      change { plan.reload.name }.to(plan_data.nickname)
        .and(change { plan.reload.amount }.to(2700))
        .and(change { plan.reload.currency }.to('cad'))
        .and(change { plan.reload.interval }.to('month'))
        .and(change { plan.reload.interval_count }.to(1))
        .and(change { plan.reload.trial_period_days }.to(7))
    )
  end
end
