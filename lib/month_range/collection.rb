# frozen_string_literal: true

class MonthRange::Collection
  attr_reader :stored_m_ranges

  def initialize(m_ranges = [])
    @stored_m_ranges = []
    m_ranges.each { |m_range| add(m_range) }
  end

  def to_a
    @stored_m_ranges.map do |collection_range|
      [collection_range.start_month.to_date, collection_range.end_month.to_date]
    end
  end

  def add(m_range)
    raise MonthRange::Error, 'Need MonthRange::MRange' unless m_range.is_a?(MonthRange::MRange)
    return @stored_m_ranges << m_range if @stored_m_ranges.empty?

    update_stored_m_ranges(m_range) do |overlapped_collection_ranges|
      [merge_range(overlapped_collection_ranges, m_range)]
    end
  end

  def subtract(m_range)
    raise MonthRange::Error, 'Need MonthRange::MRange' unless m_range.is_a?(MonthRange::MRange)
    return if @stored_m_ranges.empty?

    update_stored_m_ranges(m_range) do |overlapped_collection_ranges|
      subtract_range(overlapped_collection_ranges, m_range)
    end
  end

  private

  def overlapped_collection_ranges(m_range)
    @stored_m_ranges.select { |collection_range| collection_range.overlap?(m_range) }
  end

  def update_stored_m_ranges(m_range)
    m_ranges = overlapped_collection_ranges(m_range)
    delete_m_ranges_to_stored(m_ranges)
    add_m_ranges_to_stored(yield(m_ranges))
  end

  def delete_m_ranges_to_stored(m_ranges)
    @stored_m_ranges -= m_ranges
    @stored_m_ranges = combine_continuous_range(sort_ranges_asc(@stored_m_ranges.flatten.compact))
  end

  def add_m_ranges_to_stored(m_ranges)
    @stored_m_ranges += m_ranges
    @stored_m_ranges = combine_continuous_range(sort_ranges_asc(@stored_m_ranges.flatten.compact))
  end

  def sort_ranges_asc(m_ranges)
    return m_ranges if m_ranges.size <= 1

    m_ranges.sort { |a, b| a.start_month <=> b.start_month }
  end

  def merge_range(m_ranges, m_range)
    start_month = (m_ranges + [m_range]).map(&:start_month).min { |a, b| a <=> b }
    end_month = (m_ranges + [m_range]).map(&:end_month).max { |a, b| a <=> b }
    MonthRange::MRange.new(start_month, end_month)
  end

  def subtract_range(m_ranges, m_range)
    output_m_range = []
    m_ranges.each do |r|
      output_m_range << r.subtract(m_range)
    end
    output_m_range.flatten.compact
  end

  def combine_continuous_range(m_ranges) # rubocop:disable Metrics/CyclomaticComplexity
    return m_ranges if m_ranges.count <= 1

    before_m_range = nil
    output_m_ranges = []
    m_ranges.each_with_index do |m_range, idx|
      (before_m_range = m_range) && next if idx.zero?
      (before_m_range = before_m_range.combine(m_range)) && next if before_m_range.continuous?(m_range)
      output_m_ranges << before_m_range
      before_m_range = m_range
    end
    output_m_ranges << before_m_range unless output_m_ranges.include?(before_m_range)
  end
end
