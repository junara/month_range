# frozen_string_literal: true

require 'date'
require_relative '../month_range/error'

class MonthRange::MRange < Range
  attr_reader :start_month, :end_month
  class InvalidStartEnd < MonthRange::Error
  end

  def initialize(start_month, end_month)
    raise InvalidStartEnd unless start_month.is_a?(MonthRange::Month)
    raise InvalidStartEnd unless end_month.is_a?(MonthRange::Month) || end_month.is_a?(MonthRange::Month::Infinity)
    raise InvalidStartEnd, [start_month, end_month] unless valid_start_end_relation?(start_month, end_month)

    super(start_month, end_month)
    @start_month = start_month
    @end_month = end_month
  end

  def overlap?(m_range)
    raise "#{m_range} must be MRange." unless m_range.is_a?(MonthRange::MRange)

    true if cover?(m_range.start_month) || cover?(m_range.end_month) || m_range.cover?(self)
  end

  def non_terminated?
    end_month.infinite?
  end

  def terminated?
    !end_month.infinite?
  end

  def subtract(m_range)
    return self unless overlap?(m_range)

    output_range = []
    output_range << MonthRange::MRange.new(start_month, m_range.just_before) if cover?(m_range.start_month)
    if cover?(m_range.end_month) && m_range.terminated?
      output_range << MonthRange::MRange.new(m_range.just_after, end_month)
    end
    output_range.flatten.compact
  end

  def just_before
    start_month.prev_month(1)
  end

  def just_after
    non_terminated? ? end_month : end_month.next_month(1)
  end

  def continuous?(m_range)
    return false if m_range.nil?
    raise if start_month >= m_range.start_month
    return false if end_month.infinite?

    end_month == m_range.just_before
  end

  def combine(m_range)
    if start_month < m_range.start_month
      MonthRange::MRange.new(start_month, m_range.end_month)
    else
      MonthRange::MRange.new(m_range.start_month, end_month)
    end
  end

  private

  def valid_start_end_relation?(start_month, end_month)
    return true if end_month.nil?

    start_month <= end_month
  end
end
