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

  describe '.applicable' do
    it 'return only applicable plans' do
      applicable_plan = create(:stripe_plan, :applicable)
      create(:stripe_plan, :not_applicable)

      expect(described_class.applicable.all).to eq([applicable_plan])
    end
  end
end
