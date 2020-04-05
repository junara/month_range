# frozen_string_literal: true

RSpec.describe MonthRange::Month::Infinity do
  describe '#infinite?' do
    it { expect(described_class.new.infinite?).to eq true }
  end
  describe '#<=' do
    it { expect(described_class.new <= MonthRange::Month.create(Date.parse('2020-01-01'))).to eq false }
    it { expect(described_class.new <= described_class.new).to eq true }
  end
  describe '#>=' do
    it { expect(described_class.new >= MonthRange::Month.create(Date.parse('2020-01-01'))).to eq true }
    it { expect(described_class.new >= described_class.new).to eq true }
  end
  describe '#to_date' do
    it { expect(described_class.new.to_date).to eq nil }
  end
  describe '#<=>' do
    it { expect(described_class.new <=> MonthRange::Month.create(Date.parse('2020-01-01'))).to eq 1 }
    it { expect(described_class.new <=> described_class.new).to eq 0 }
  end
end
