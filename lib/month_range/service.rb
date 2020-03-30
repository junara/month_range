# frozen_string_literal: true

class MonthRange::Service
  # Subtract range
  # @param [MonthRange::MRange] range_array
  # @param [Array] from_range_arrays
  # @example from_range_arrays
  #  from_range_arrays = [
  #    [Date.parse('2020-01-01'), Date.parse('2020-04-01')],
  #    [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
  #    [Date.parse('2020-12-01'), nil]
  #  ]
  # @example Simple
  #  range_array = [Date.parse('2020-02-01'), Date.parse('2020-03-01')]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>], [#<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>, #<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>], [#<Date: 2020-07-01 ((2459032j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]
  # @example 複数期間にまたがる
  #  range_array = [Date.parse('2020-03-01'), Date.parse('2020-08-01')]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-02-01 ((2458881j,0s,0n),+0s,2299161j)>], [#<Date: 2020-09-01 ((2459094j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]
  # @example 期間内
  #  range_array = [Date.parse('2020-02-01'), Date.parse('2020-03-01')]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>], [#<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>, #<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>], [#<Date: 2020-07-01 ((2459032j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]
  # @example 終端なし
  #  range_array = [Date.parse('2020-05-01'), nil]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-04-01 ((2458941j,0s,0n),+0s,2299161j)>]]
  def self.subtraction(range_array, from_range_arrays)
    collection = range_arrays_to_collection(from_range_arrays)
    start_month = range_array[0]
    end_month = range_array[1]
    m_range = MonthRange::MRange.new(start_month, end_month)
    collection.subtract(m_range)
    collection.to_a
  end

  # Union range
  # @param [MonthRange::MRange] range_array
  # @param [Array of MonthRange::MRange] from_range_arrays
  # @return [Array of MonthRange::MRange]
  # @example from_range_arrays
  #  from_range_arrays = [
  #    [Date.parse('2020-01-01'), Date.parse('2020-04-01')],
  #    [Date.parse('2020-07-01'), Date.parse('2020-10-01')],
  #    [Date.parse('2020-12-01'), nil]
  #  ]
  # @example Simple
  #  range_array = [Date.parse('2020-03-01'), Date.parse('2020-05-01')]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-05-01 ((2458971j,0s,0n),+0s,2299161j)>], [#<Date: 2020-07-01 ((2459032j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]
  # @example 複数期間にまたがる
  #  range_array = [Date.parse('2020-03-01'), Date.parse('2020-08-01')]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]
  # @example 隣り合った期間を連結
  #  range_array = [Date.parse('2020-05-01'), Date.parse('2020-06-01')]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, #<Date: 2020-10-01 ((2459124j,0s,0n),+0s,2299161j)>], [#<Date: 2020-12-01 ((2459185j,0s,0n),+0s,2299161j)>, nil]]
  # @example 終端なし
  #  range_array = [Date.parse('2020-05-01'), nil]
  #  MonthRange::Service.add(range_array, from_range_arrays)
  #
  #  #=> [[#<Date: 2020-01-01 ((2458850j,0s,0n),+0s,2299161j)>, nil]]
  def self.add(range_array, from_range_arrays)
    collection = range_arrays_to_collection(from_range_arrays)
    start_month = range_array[0]
    end_month = range_array[1]
    m_range = MonthRange::MRange.new(start_month, end_month)
    collection.add(m_range)
    collection.to_a
  end

  # Change to MonthRange::Collection
  # @param [[[Date, Date], [Date, Date],]] range_arrays
  # @return [MonthRange::Collection]
  def self.range_arrays_to_collection(range_arrays)
    collection = MonthRange::Collection.new
    range_arrays.each do |range|
      start_month = range[0]
      end_month = range[1]
      m_range = MonthRange::MRange.new(start_month, end_month)
      collection.add(m_range)
    end
    collection
  end
end
