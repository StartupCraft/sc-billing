# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::Charges::CreateOperation, :stripe do
  subject(:call) do
    described_class.new.call(charge_data)
  end

  let(:customer) { Stripe::Customer.create }
  let(:charge_data) { ::Stripe::Charge.create(amount: 100_500, currency: 'usd', customer: customer.id) }

  before do
    create(:user, stripe_customer_id: customer.id)
  end

  it 'creates charge' do
    expect { call }.to(
      change(::SC::Billing::Stripe::Charge, :count).by(1)
    )
  end

  context 'when with extra attributes' do
    subject(:call) do
      described_class.new.call(charge_data, extra_params)
    end

    let(:extra_params) { {additional_attr: 'some value'} }

    it 'creates charge', :aggregate_failures do
      expect { call }.to(
        change(::SC::Billing::Stripe::Charge, :count).by(1)
      )
      expect(::SC::Billing::Stripe::Charge.last.additional_attr).to eq('some value')
    end
  end
end
