# frozen_string_literal: true

RSpec.describe SC::Billing::Stripe::SyncProductsService do
  let(:service) { described_class.new }

  describe '#call' do
    subject(:call) do
      service.call
    end

    let(:product) { Stripe::Product.construct_from(name: 'Management', id: 'prod_Cmpsds2X8lxkG0') }
    let(:products_list) { Stripe::ListObject.construct_from(data: [product]) }

    before do
      allow(Stripe::Product).to receive(:all).and_return(products_list)
    end

    context 'when plans do not exist now' do
      it 'creates plans' do
        expect { call }.to change(::SC::Billing::Stripe::Product, :count).by(1)
      end
    end

    context 'when plans already exists' do
      before do
        create(:stripe_product, stripe_id: 'prod_Cmpsds2X8lxkG0', name: 'Management')
      end

      it 'not creates plans' do
        expect { call }.not_to change(::SC::Billing::Stripe::Product, :count)
      end
    end
  end
end
