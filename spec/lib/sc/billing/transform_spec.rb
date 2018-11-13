# frozen_string_literal: true

RSpec.describe SC::Billing::Transform do
  describe '.attrs_to_hash' do
    subject(:transform) do
      described_class[:attrs_to_hash, %i[a b c]]
    end

    let(:struct) { Struct.new(:a, :b, :c, :d, :e, keyword_init: true) }

    it :aggregate_failures do
      input = struct.new(a: 1, b: 2, c: 3)

      expect(transform.call(input)).to eq(
        a: 1,
        b: 2,
        c: 3
      )
    end

    it do
      input = struct.new(a: 1, d: 4, e: 5)

      expect(transform.call(input)).to eq(
        a: 1,
        b: nil,
        c: nil
      )
    end
  end

  describe '.timestamp_to_time' do
    subject(:transform) do
      described_class[:timestamp_to_time, %i[as_of due_to]]
    end

    it 'transforms correctly' do
      input = {as_of: 1_528_549_095, due_to: 1_528_559_095}

      expect(transform.call(input)).to eq(
        as_of: Time.new(2018, 6, 9, 12, 58, 15),
        due_to: Time.new(2018, 6, 9, 15, 44, 55)
      )
    end
  end
end
