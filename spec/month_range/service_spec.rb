# frozen_string_literal: true

RSpec.describe MonthRange::Service do
  def to_date(date_str)
    date_str.nil? ? date_str : Date.parse(date_str)
  end

  def to_range_array(date_str_range)
    [to_date(date_str_range[0]), to_date(date_str_range[1])]
  end

  def to_range_arrays(date_str_array)
    date_str_array.map do |date_str_range|
      to_range_array(date_str_range)
    end
  end

  describe '#add' do
    let(:subject) { described_class.add(range_array, from_range_arrays) }
    shared_examples 'add range_array to from_range_arrays' do |date_str_range, from_date_str_ranges, result_date_str_ranges|
      let(:range_array) { to_range_array(date_str_range) }
      let(:from_range_arrays) { to_range_arrays(from_date_str_ranges) }
      let(:result_range_arrays) { to_range_arrays(result_date_str_ranges) }
      it "should return #{result_date_str_ranges} by adding ##{date_str_range} to #{from_date_str_ranges}" do
        expect(subject).to eq(result_range_arrays)
      end
    end
    context 'Num of from_range_arrays is one' do
      context 'added 1 month range' do
        add = %w[2020-06-01 2020-06-01]
        it_should_behave_like 'add range_array to from_range_arrays',
                              add,
                              [],
                              [%w[2020-06-01 2020-06-01]]
        context 'to 1 month range' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-04-01 2020-04-01]],
                                [%w[2020-04-01 2020-04-01], %w[2020-06-01 2020-06-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-05-01 2020-05-01]],
                                [%w[2020-05-01 2020-06-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-06-01 2020-06-01]],
                                [%w[2020-06-01 2020-06-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-07-01 2020-07-01]],
                                [%w[2020-06-01 2020-07-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-08-01 2020-08-01]],
                                [%w[2020-06-01 2020-06-01], %w[2020-08-01 2020-08-01]]
        end
        context 'to infinity range' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-04-01', nil]],
                                [['2020-04-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-05-01', nil]],
                                [['2020-05-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-06-01', nil]],
                                [['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-07-01', nil]],
                                [['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-08-01', nil]],
                                [%w[2020-06-01 2020-06-01], ['2020-08-01', nil]]
        end
      end
      context 'added infinity range' do
        add = ['2020-06-01', nil]
        it_should_behave_like 'add range_array to from_range_arrays',
                              add,
                              [],
                              [['2020-06-01', nil]]
        context 'to 1 month range' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-04-01 2020-04-01]],
                                [%w[2020-04-01 2020-04-01], ['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-05-01 2020-05-01]],
                                [['2020-05-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-06-01 2020-06-01]],
                                [['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-07-01 2020-07-01]],
                                [['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [%w[2020-08-01 2020-08-01]],
                                [['2020-06-01', nil]]
        end
        context 'to infinity range' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-04-01', nil]],
                                [['2020-04-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-05-01', nil]],
                                [['2020-05-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-06-01', nil]],
                                [['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-07-01', nil]],
                                [['2020-06-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                add,
                                [['2020-08-01', nil]],
                                [['2020-06-01', nil]]
        end
      end
    end

    context 'Num of from_range_arrays is 3' do
      context 'all range is terminated' do
        to = [%w[2020-05-01 2020-06-01], %w[2020-02-01 2020-03-01], %w[2020-09-01 2020-10-01]]
        context 'added range of start month is earliest.' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2019-12-01],
                                to,
                                [%w[2019-12-01 2019-12-01], %w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-01-01],
                                to,
                                [%w[2019-12-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-02-01],
                                to,
                                [%w[2019-12-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-03-01],
                                to,
                                [%w[2019-12-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-04-01],
                                to,
                                [%w[2019-12-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-05-01],
                                to,
                                [%w[2019-12-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-06-01],
                                to,
                                [%w[2019-12-01 2020-06-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-07-01],
                                to,
                                [%w[2019-12-01 2020-07-01], %w[2020-09-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-08-01],
                                to,
                                [%w[2019-12-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-09-01],
                                to,
                                [%w[2019-12-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-10-01],
                                to,
                                [%w[2019-12-01 2020-10-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-11-01],
                                to,
                                [%w[2019-12-01 2020-11-01]]
        end
        context 'added range of end month is latest.' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-12-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-10-01], %w[2020-12-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-11-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-10-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-09-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-08-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-08-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-07-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-06-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-05-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-04-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-03-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-02-01 2020-12-01],
                                to,
                                [%w[2020-02-01 2020-12-01]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2020-01-01 2020-12-01],
                                to,
                                [%w[2020-01-01 2020-12-01]]
        end
        context 'added range of end month is infinity' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2019-12-01', nil],
                                to,
                                [['2019-12-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-01-01', nil],
                                to,
                                [['2020-01-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-02-01', nil],
                                to,
                                [['2020-02-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-03-01', nil],
                                to,
                                [['2020-02-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-04-01', nil],
                                to,
                                [['2020-02-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-05-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], ['2020-05-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-06-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], ['2020-05-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-07-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], ['2020-05-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-08-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], ['2020-08-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-09-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], ['2020-09-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-10-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], ['2020-09-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-11-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], ['2020-09-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-12-01', nil],
                                to,
                                [%w[2020-02-01 2020-03-01], %w[2020-05-01 2020-06-01], %w[2020-09-01 2020-10-01], ['2020-12-01', nil]]
        end
      end
      context '2 ranges is unterminated' do
        to = [%w[2020-05-01 2020-06-01], ['2020-02-01', nil], ['2020-09-01', nil]]
        context 'added range of start month is earliest.' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2019-12-01],
                                to,
                                [%w[2019-12-01 2019-12-01], ['2020-02-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-01-01],
                                to,
                                [['2019-12-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-06-01],
                                to,
                                [['2019-12-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                %w[2019-12-01 2020-12-01],
                                to,
                                [['2019-12-01', nil]]
        end
        context 'added range of end month is infinity' do
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2019-12-01', nil],
                                to,
                                [['2019-12-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-01-01', nil],
                                to,
                                [['2020-01-01', nil]]
          it_should_behave_like 'add range_array to from_range_arrays',
                                ['2020-03-01', nil],
                                to,
                                [['2020-02-01', nil]]
        end
      end
    end
    context 'miscellaneous' do
      context do
        let(:from_range_arrays) do
          to_range_arrays(
            [
              %w[2020-01-01 2020-04-01],
              %w[2020-07-01 2020-10-01],
              ['2020-12-01', nil]
            ]
          )
        end
        context do
          let(:range_array) { to_range_array(%w[2020-02-01 2020-03-01]) }
          it {
            is_expected.to eq to_range_arrays [
              %w[2020-01-01 2020-04-01],
              %w[2020-07-01 2020-10-01],
              ['2020-12-01', nil]
            ]
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
      context do
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
      context 'single range without nil' do
        let(:from_range_arrays) do
          [[Date.parse('2020-02-01'), Date.parse('2020-02-01')]]
        end
        context do
          let(:range_array) { [Date.parse('2019-12-01'), Date.parse('2019-12-01')] }
          it {
            is_expected.to eq [[Date.parse('2019-12-01'), Date.parse('2019-12-01')],
                               [Date.parse('2020-02-01'), Date.parse('2020-02-01')]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-01-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-02-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-02-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-02-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-03-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-03-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-02-01')] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), Date.parse('2020-02-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-03-01')] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), Date.parse('2020-03-01')]] }
        end
      end
      context 'single range with nil' do
        let(:from_range_arrays) do
          [[Date.parse('2020-02-01'), nil]]
        end
        context do
          let(:range_array) { [Date.parse('2019-12-01'), Date.parse('2019-12-01')] }
          it {
            is_expected.to eq [[Date.parse('2019-12-01'), Date.parse('2019-12-01')],
                               [Date.parse('2020-02-01'), nil]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-01-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-02-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-03-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-02-01')] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-03-01')] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), nil]] }
        end
      end

      context '2 ranges without nil' do
        let(:from_range_arrays) do
          [[Date.parse('2020-05-01'), Date.parse('2020-06-01')],
           [Date.parse('2020-02-01'), Date.parse('2020-03-01')]]
        end
        context do
          let(:range_array) { [Date.parse('2019-12-01'), Date.parse('2019-12-01')] }
          it {
            is_expected.to eq [[Date.parse('2019-12-01'), Date.parse('2019-12-01')],
                               [Date.parse('2020-02-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), Date.parse('2020-06-01')]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-01-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), Date.parse('2020-06-01')]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-03-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), Date.parse('2020-06-01')]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-04-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-06-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-05-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-06-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-07-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-07-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-04-01'), Date.parse('2020-04-01')] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), Date.parse('2020-06-01')]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-06-01'), Date.parse('2020-07-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-02-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), Date.parse('2020-07-01')]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-02-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-04-01'), nil] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-05-01'), nil] }
          it {
            is_expected.to eq [[Date.parse('2020-02-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), nil]]
          }
        end
      end
      context '2 ranges with nil' do
        let(:from_range_arrays) do
          [[Date.parse('2020-05-01'), nil],
           [Date.parse('2020-02-01'), Date.parse('2020-03-01')]]
        end
        context do
          let(:range_array) { [Date.parse('2019-12-01'), Date.parse('2019-12-01')] }
          it {
            is_expected.to eq [[Date.parse('2019-12-01'), Date.parse('2019-12-01')],
                               [Date.parse('2020-02-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), nil]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-01-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), nil]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-03-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), nil]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-04-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-05-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-07-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-04-01'), Date.parse('2020-04-01')] }
          it { is_expected.to eq [[Date.parse('2020-02-01'), nil]] }
        end
        context do
          let(:range_array) { [Date.parse('2020-06-01'), Date.parse('2020-07-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-02-01'), Date.parse('2020-03-01')],
                               [Date.parse('2020-05-01'), nil]]
          }
        end
      end

      context '2 ranges overlapped' do
        let(:from_range_arrays) do
          [[Date.parse('2020-05-01'), nil],
           [Date.parse('2020-02-01'), Date.parse('2020-06-01')],
           [Date.parse('2020-01-01'), Date.parse('2020-02-01')]]
        end
        context do
          let(:range_array) { [Date.parse('2020-06-01'), Date.parse('2020-07-01')] }
          it { is_expected.to eq [[Date.parse('2020-01-01'), nil]] }
        end
      end
      context '3 ranges without nil' do
        let(:from_range_arrays) do
          [[Date.parse('2020-06-01'), Date.parse('2020-08-01')],
           [Date.parse('2020-04-01'), Date.parse('2020-04-01')],
           [Date.parse('2020-01-01'), Date.parse('2020-02-01')]]
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-04-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
                               [Date.parse('2020-06-01'), Date.parse('2020-08-01')]]
          }
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-07-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-08-01')]]
          }
        end
      end
      context '3 ranges with nil' do
        let(:from_range_arrays) do
          [[Date.parse('2020-06-01'), nil],
           [Date.parse('2020-04-01'), Date.parse('2020-04-01')],
           [Date.parse('2020-01-01'), Date.parse('2020-02-01')]]
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-04-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
                               [Date.parse('2020-06-01'), nil]]
          }
        end
      end
      context 'not overlapped' do
        let(:from_range_arrays) do
          [[Date.parse('2020-06-01'), nil]]
        end
        context do
          let(:range_array) { [Date.parse('2020-01-01'), Date.parse('2020-04-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
                               [Date.parse('2020-06-01'), nil]]
          }
        end
      end

      context 'overlapped collection' do
        let(:from_range_arrays) do
          [
            [Date.parse('2020-06-01'), Date.parse('2020-06-01')],
            [Date.parse('2020-01-01'), Date.parse('2020-06-01')]
          ]
        end
        context do
          let(:range_array) { [Date.parse('2020-09-01'), Date.parse('2020-10-01')] }
          it {
            is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-06-01')],
                               [Date.parse('2020-09-01'), Date.parse('2020-10-01')]]
          }
        end
      end
    end
  end

  describe '#subtraction' do
    let(:subject) { described_class.subtraction(range_array, from_range_arrays) }
    context do
      let(:from_range_arrays) do
        [[Date.parse('2020-01-01'), Date.parse('2020-04-01')],
         [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
         [Date.parse('2020-12-01'), nil]]
      end
      context do
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

    context do
      let(:from_range_arrays) do
        [
          [Date.parse('2020-12-01'), nil],
          [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
          [Date.parse('2020-01-01'), Date.parse('2020-04-01')]
        ]
      end
      context do
        let(:range_array) { [Date.parse('2020-02-01'), nil] }
        it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-01-01')]] }
      end
      context do
        let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-02-01')] }
        it {
          is_expected.to eq [
            [Date.parse('2020-01-01'), Date.parse('2020-01-01')],
            [Date.parse('2020-03-01'), Date.parse('2020-04-01')],
            [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
            [Date.parse('2020-12-01'), nil]
          ]
        }
      end
      context do
        let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-07-01')] }
        it {
          is_expected.to eq [
            [Date.parse('2020-01-01'), Date.parse('2020-01-01')],
            [Date.parse('2020-08-01'), Date.parse('2020-10-01')],
            [Date.parse('2020-12-01'), nil]
          ]
        }
      end
      context do
        let(:range_array) { [Date.parse('2021-01-01'), Date.parse('2021-02-01')] }
        it {
          is_expected.to eq [
            [Date.parse('2020-01-01'), Date.parse('2020-04-01')],
            [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
            [Date.parse('2020-12-01'), Date.parse('2020-12-01')],
            [Date.parse('2021-03-01'), nil]
          ]
        }
      end
      context do
        let(:range_array) { [Date.parse('2020-02-01'), Date.parse('2020-11-01')] }
        it {
          is_expected.to eq [
            [Date.parse('2020-01-01'), Date.parse('2020-01-01')],
            [Date.parse('2020-12-01'), nil]
          ]
        }
      end
      context do
        let(:range_array) { [Date.parse('2010-02-01'), nil] }
        it { is_expected.to eq [] }
      end
      context do
        let(:range_array) { [Date.parse('2010-02-01'), Date.parse('2020-12-01')] }
        it { is_expected.to eq [[Date.parse('2021-01-01'), nil]] }
      end
    end
    context do
      let(:from_range_arrays) do
        [
          [Date.parse('2020-07-01'), nil],
          [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
          [Date.parse('2020-01-01'), Date.parse('2020-08-01')]
        ]
      end
      context do
        let(:range_array) { [Date.parse('2020-02-01'), nil] }
        it { is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-01-01')]] }
      end
      context do
        let(:range_array) { [Date.parse('2020-04-01'), Date.parse('2020-10-01')] }
        it {
          is_expected.to eq [[Date.parse('2020-01-01'), Date.parse('2020-03-01')],
                             [Date.parse('2020-11-01'), nil]]
        }
      end
    end
  end
end
