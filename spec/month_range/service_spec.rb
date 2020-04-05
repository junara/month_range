# frozen_string_literal: true

RSpec.describe MonthRange::Service do
  describe '#add' do
    let(:subject) { described_class.add(range_array, from_range_arrays) }
    context '' do
      let(:from_range_arrays) do
        [
          [Date.parse('2020-01-01'), Date.parse('2020-04-01')],
          [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
          [Date.parse('2020-12-01'), nil]
        ]
      end

      context '' do
        let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-03-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
                             [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
                             [Date.parse('2020-12-01'), nil]]
        }
      end
      context '複数期間にまたがる' do
        let(:range_array) { [Date.parse('2020-03-01'), Date.parse('2020-08-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-10-01')],
                             [Date.parse('2020-12-01'), nil]]
        }
      end
      context '期間内' do
        let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-03-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
                             [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
                             [Date.parse('2020-12-01'), nil]]
        }
      end
      context '終端なし' do
        let(:range_array) { [Date.parse('2020-05-01'), nil] }
        it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
      end
    end
    context '' do
      let(:from_range_arrays) do
        [
          [Date.parse('2020-01-01'), Date.parse('2020-04-01')],
          [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
          [Date.parse('2020-12-01'), nil]
        ]
      end
      let(:range_array) { [Date.parse('2019-12-01'), Date.parse('2021-01-01')] }
      it { is_expected.to eq [[Date.parse('2019-12-01'), nil]] }
    end
  end

  describe '#subtraction' do
    let(:subject) { described_class.subtraction(range_array, from_range_arrays) }
    context '' do
      let(:from_range_arrays) do
        [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
         [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
         [Date.parse('2020-12-01'), nil]]
      end
      context '' do
        let(:range_array) { [Date.parse('2020-03-01'), Date.parse('2020-05-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-02-01')],
                             [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
                             [Date.parse('2020-12-01'), nil]]
        }
      end
      context '複数期間にまたがる' do
        let(:range_array) { [Date.parse('2020-03-01'), Date.parse('2020-08-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-02-01')],
                             [Date.parse('2020-09-01'), Date.parse('2020-10-01')],
                             [Date.parse('2020-12-01'), nil]]
        }
      end
      context '期間内' do
        let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-03-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-01-01')],
                             [Date.parse('2020-04-01'), Date.parse('2020-04-01')],
                             [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
                             [Date.parse('2020-12-01'), nil]]
        }
      end
      context '終端なし' do
        let(:range_array) { [Date.parse('2020-05-01'), nil] }
        it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-04-01')]] }
      end
    end

    context '' do
      let(:from_range_arrays) do
        [
          [Date.parse('2020-01-01'), Date.parse('2020-04-01')],
          [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
          [Date.parse('2020-12-01'), nil]
        ]
      end
      let(:range_array) { [Date.parse('2010-02-01'), nil] }
      it { is_expected.to eq [] }
    end
  end
end
