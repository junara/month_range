# frozen_string_literal: true

class MonthRange::Collection
  attr_reader :self_ranges

  def initialize
    @self_ranges = []
  end

  def add(range)
    raise MonthRange::Error, 'Need MonthRange::Range' unless range.is_a?(MonthRange::Range)

    self_ranges << range if self_ranges.empty?
    overlapped_ranges = self_ranges.select { |self_range| self_range.overlap?(range) }
    self_ranges -= overlapped_ranges
    self_ranges += merged_range(sort_ranges_asc!(overlapped_ranges))
    sort_ranges_asc!(self_ranges)
  end

  private

  def sort_ranges_asc!(ranges)
    return if ranges.empty?

    ranges.sort_by! { |a, b| a.start_month <=> b.start_month }
  end

  def merged_range(ranges)
    start_month = ranges.first.start_month
    end_month = ranges.last.end_month
    MonthRange::Range.new(start_month, end_month)
  end
end
