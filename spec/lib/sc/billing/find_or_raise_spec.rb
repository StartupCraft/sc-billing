# frozen_string_literal: true

RSpec.describe SC::Billing::FindOrRaise do
  let(:klass) do
    Class.new do
      include SC::Billing::FindOrRaise[user: :stripe_customer_id]
    end.new
  end

  describe '#find_or_raise_entity' do
    it 'responds to method' do
      expect(klass).to respond_to(:find_or_raise_user)
    end
  end

  describe '#find_entity' do
    it 'responds to method' do
      expect(klass).to respond_to(:find_user)
    end
  end

  describe '#raise_if_entity_not_found' do
    it 'responds to method' do
      expect(klass).to respond_to(:raise_if_user_not_found)
    end
  end

  context 'when pass several entities' do
    let(:klass) do
      Class.new do
        include SC::Billing::FindOrRaise[user: :stripe_customer_id, invoice: :stripe_id]
      end.new
    end

    describe '#find_or_raise_entity' do
      it 'responds to method', :aggregate_failures do
        expect(klass).to respond_to(:find_or_raise_user)
        expect(klass).to respond_to(:find_or_raise_invoice)
      end
    end

    describe '#find_entity' do
      it 'responds to method', :aggregate_failures do
        expect(klass).to respond_to(:find_user)
        expect(klass).to respond_to(:find_invoice)
      end
    end

    describe '#raise_if_entity_not_found' do
      it 'responds to method', :aggregate_failures do
        expect(klass).to respond_to(:raise_if_user_not_found)
        expect(klass).to respond_to(:raise_if_invoice_not_found)
      end
    end
  end
end
