# frozen_string_literal: true

RSpec.describe SC::Billing::Users::CreatePaymentSourceService do
  let(:service) { described_class.new(user) }
  let(:user) { create(:user) }

  describe '#call' do
    subject(:call) do
      service.call(stripe_data_object)
    end

    context 'when object is card' do
      let(:stripe_data_object) { Stripe::Card.construct_from(id: '1', object: 'card') }

      it 'creates payment source', :aggregate_failures do
        expect { call }.to change(::SC::Billing::Stripe::PaymentSource, :count).by(1)

        payment_source = call
        expect(payment_source.object).to eq('card')
        expect(payment_source.user_id).to eq(user.id)
        expect(payment_source.stripe_id).to eq('1')
        expect(payment_source.stripe_data).to eq('id' => '1', 'object' => 'card')
      end
    end

    context 'when object is source' do
      let(:stripe_data_object) do
        Stripe::Card.construct_from(id: '2', object: 'source', status: 'chargeable', type: 'bitcoin')
      end

      it 'creates payment source', :aggregate_failures do
        expect { call }.to change(::SC::Billing::Stripe::PaymentSource, :count).by(1)

        payment_source = call
        expect(payment_source.object).to eq('source')
        expect(payment_source.user_id).to eq(user.id)
        expect(payment_source.stripe_id).to eq('2')
        expect(payment_source.stripe_data).to eq(
          'id' => '2',
          'object' => 'source',
          'status' => 'chargeable',
          'type' => 'bitcoin'
        )
        expect(payment_source.status).to eq('chargeable')
        expect(payment_source.type).to eq('bitcoin')
      end
    end
  end
end
