# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Subscription, type: :model do
  describe '#active?' do
    context 'when subscription is active' do
      let(:subscription) { build_stubbed(:stripe_subscription, :active) }

      it { expect(subscription).to be_active }
    end

    context 'when subscription is not active' do
      let(:subscription) { build_stubbed(:stripe_subscription, :trialing) }

      it { expect(subscription).not_to be_active }
    end
  end

  describe '#trialing?' do
    context 'when subscription is trialing' do
      let(:subscription) { build_stubbed(:stripe_subscription, :trialing) }

      it { expect(subscription).to be_trialing }
    end

    context 'when subscription is not trialing' do
      let(:subscription) { build_stubbed(:stripe_subscription, :active) }

      it { expect(subscription).not_to be_trialing }
    end
  end

  describe '#past_due?' do
    context 'when subscription is past_due' do
      let(:subscription) { build_stubbed(:stripe_subscription, :past_due) }

      it { expect(subscription).to be_past_due }
    end

    context 'when subscription is not past_due' do
      let(:subscription) { build_stubbed(:stripe_subscription, :active) }

      it { expect(subscription).not_to be_past_due }
    end
  end

  describe '#canceled?' do
    context 'when subscription is canceled' do
      let(:subscription) { build_stubbed(:stripe_subscription, :canceled) }

      it { expect(subscription).to be_canceled }
    end

    context 'when subscription is not canceled' do
      let(:subscription) { build_stubbed(:stripe_subscription, :active) }

      it { expect(subscription).not_to be_canceled }
    end
  end

  describe '#unpaid?' do
    context 'when subscription is unpaid' do
      let(:subscription) { build_stubbed(:stripe_subscription, :unpaid) }

      it { expect(subscription).to be_unpaid }
    end

    context 'when subscription is not unpaid' do
      let(:subscription) { build_stubbed(:stripe_subscription, :active) }

      it { expect(subscription).not_to be_unpaid }
    end
  end
end
