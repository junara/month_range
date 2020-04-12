# frozen_string_literal: true

RSpec.describe MonthRange::MRange do
  describe '#new' do
    it {
      expect do
        described_class.new(MonthRange::Month.create(Date.parse('2020-01-01')), MonthRange::Month.create(Date.parse('2020-01-01')))
      end.not_to raise_error(described_class::InvalidStartEnd)
    }
    it {
      expect do
        described_class.new(MonthRange::Month.create(Date.parse('2020-01-01')), MonthRange::Month::Infinity.new)
      end.not_to raise_error(described_class::InvalidStartEnd)
    }
    it {
      expect do
        described_class.new(MonthRange::Month.create(Date.parse('2020-01-01')), MonthRange::Month.create(Date.parse('2019-12-01')))
      end.to raise_error(described_class::InvalidStartEnd)
    }
  end
  describe '#overlap?' do
    it {
      expect do
        described_class.new(MonthRange::Month.create(Date.parse('2020-01-01')), MonthRange::Month.create(Date.parse('2020-01-01'))).overlap?('hoge')
      end.to raise_error(described_class::NotMRange)
    }
  end
end
