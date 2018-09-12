# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Plan, type: :model do
  describe '#free?' do
    let(:plan) { build_stubbed(:stripe_plan, amount: 0) }

    it { expect(plan).to be_free }
  end

  describe '#paid?' do
    let(:plan) { build_stubbed(:stripe_plan, amount: 100) }

    it { expect(plan).to be_paid }
  end
end
