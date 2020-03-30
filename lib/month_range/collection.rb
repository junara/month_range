# frozen_string_literal: true

class MonthRange::Collection
  attr_reader :collection_ranges

  def initialize
    @collection_ranges = []
  end

  def to_a
    @collection_ranges.map { |collection_rang| [collection_rang.start_month, collection_rang.end_month] }
  end

  def add(range)
    raise MonthRange::Error, 'Need MonthRange::MRange' unless range.is_a?(MonthRange::MRange)
    return @collection_ranges << range if @collection_ranges.empty?

    overlapped_collection_ranges = @collection_ranges.select { |collection_range| collection_range.overlap?(range) }
    return @collection_ranges if overlapped_collection_ranges.nil?

    update_collection_ranges(overlapped_collection_ranges, range) { |rs, r| [merge_range(rs, r)] }
  end

  def subtract(range)
    raise MonthRange::Error, 'Need MonthRange::MRange' unless range.is_a?(MonthRange::MRange)
    raise if @collection_ranges.empty?

    overlapped_collection_ranges = @collection_ranges.select { |collection_range| collection_range.overlap?(range) }
    return @collection_ranges if overlapped_collection_ranges.nil?

    update_collection_ranges(overlapped_collection_ranges, range) { |rs, r| subtract_range(rs, r) }
  end

  def self.new_from_date_range_array(date_range_array)
    collection = new
    date_range_array.each do |range|
      start_month = range[0]
      end_month = range[1]
      m_range = MonthRange::MRange.new(start_month, end_month)
      collection.add(m_range)
    end
    collection
  end

  private

  def update_collection_ranges(overlapped_collection_ranges, range)
    @collection_ranges -= overlapped_collection_ranges
    @collection_ranges += yield(overlapped_collection_ranges, range)
    @collection_ranges = sort_ranges_asc(@collection_ranges.flatten.compact)
    @collection_ranges = combine_continuous_range(@collection_ranges)
    @collection_ranges
  end

  def sort_ranges_asc(ranges)
    return ranges if ranges.size <= 1

    ranges.sort { |a, b| a.start_month <=> b.start_month }
  end

  def merge_range(ranges, range)
    start_month = (ranges + [range]).map(&:start_month).min { |a, b| a <=> b }
    end_month = if (ranges + [range]).any?(&:non_terminated?)
                  nil
                else
                  (ranges + [range]).map(&:end_month).max { |a, b| a <=> b }
                end
    MonthRange::MRange.new(start_month, end_month)
  end

  def subtract_range(ranges, range)
    output_range = []
    ranges.each do |r|
      output_range << r.subtract(range)
    end
    output_range.flatten.compact
  end

  def combine_continuous_range(ranges)
    return ranges if ranges.count <= 1

    temp_range = nil
    output_ranges = []
    ranges.each_with_index do |range, idx|
      (temp_range = range) && next if idx.zero?

      if idx == ranges.size - 1 && continuous?(temp_range, range)
        output_ranges << MonthRange::MRange.new(temp_range.start_month, range.end_month)
        next
      elsif idx == ranges.size - 1
        output_ranges << temp_range
        output_ranges << range
        next
      elsif continuous?(temp_range, range)
        temp_range = MonthRange::MRange.new(temp_range.start_month, range.end_month)
        next
      end
      output_ranges << temp_range
      temp_range = range
    end
    output_ranges
  end

  def continuous?(range, next_range)
    return false if range.nil? || next_range.nil?
    raise if range.start_month >= next_range.start_month
    return false if range.end_month.nil?

    range.end_month == next_range.just_before
  end
end
