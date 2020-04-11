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
    m_ranges = from_range_arrays.map do |range|
      MonthRange::MRange.new(
        MonthRange::Month.create(range[0]),
        MonthRange::Month.create(range[1])
      )
    end
    collection = MonthRange::Collection.new(m_ranges)

    collection.subtract(
      MonthRange::MRange.new(
        MonthRange::Month.create(range_array[0]),
        MonthRange::Month.create(range_array[1])
      )
    )
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
    m_ranges = from_range_arrays.map do |range|
      MonthRange::MRange.new(
        MonthRange::Month.create(range[0]),
        MonthRange::Month.create(range[1])
      )
    end
    collection = MonthRange::Collection.new(m_ranges)

    collection.add(MonthRange::MRange.new(
                     MonthRange::Month.create(range_array[0]),
                     MonthRange::Month.create(range_array[1])
                   ))
    collection.to_a
  end
end
