# frozen_string_literal: true

RSpec.describe MonthRange::MRange do
  describe '#new' do
    it { expect { described_class.new(MonthRange::Month.create(Date.parse('2020-01-01')), MonthRange::Month.create(Date.parse('2019-12-01'))) }.to raise_error(described_class::InvalidStartEnd) }
  end
end
