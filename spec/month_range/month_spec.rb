# frozen_string_literal: true

RSpec.describe MonthRange::Month do
  describe 'create' do
    it { expect(described_class.create(Date.parse('2020-01-01')).to_date).to eq Date.parse('2020-01-01') }
    it { expect(described_class.create(nil)).to eq MonthRange::Month::Infinity.new }
    it { expect(described_class.create(nil).to_date).to eq nil }
    it { expect { described_class.create(Date.parse('2020-01-02')) }.to raise_error(described_class::InvalidMonthFormat) }
    it { expect { described_class.create(Time.new('2020-01-01')) }.to raise_error(described_class::InvalidMonthFormat) }
  end
end
