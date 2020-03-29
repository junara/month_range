# frozen_string_literal: true

class MonthRange::Collection
  attr_reader :collection_ranges

  def initialize
    @collection_ranges = []
  end

  def add(range)
    raise MonthRange::Error, 'Need MonthRange::MRange' unless range.is_a?(MonthRange::MRange)
    return @collection_ranges << range if @collection_ranges.empty?

    overlapped_collection_ranges = @collection_ranges.select { |collection_range| collection_range.overlap?(range) }
    return @collection_ranges if overlapped_collection_ranges.nil?

    @collection_ranges -= overlapped_collection_ranges
    @collection_ranges += [merged_range(overlapped_collection_ranges, range)]
    @collection_ranges = sort_ranges_asc(@collection_ranges)
    @collection_ranges
  end

  private

  def sort_ranges_asc(ranges)
    return if ranges.empty?
    return ranges if ranges.size == 1

    ranges.sort { |a, b| a.start_month <=> b.start_month }
  end

  def merged_range(ranges, range)
    start_month = (ranges + [range]).map(&:start_month).min { |a, b| a <=> b }
    end_month = if (ranges + [range]).any?(&:non_terminated?)
                  nil
                else
                  (ranges + [range]).map(&:end_month).max { |a, b| a <=> b }
                end
    MonthRange::MRange.new(start_month, end_month)
  end
end
