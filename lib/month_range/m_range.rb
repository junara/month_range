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
    raise InvalidStartEnd [start_month, end_month] unless valid_start_end_relation?(start_month, end_month)

    super(start_month, end_month)
    @start_month = start_month
    @end_month = end_month
  end

  def overlap?(range)
    raise "#{range} must be MRange." unless range.is_a?(MonthRange::MRange)

    if cover?(range.start_month) || cover?(range.end_month) || (range.start_month <= start_month && end_month <= range.end_month)
      true
    end
  end

  def non_terminated?
    end_month.infinite?
  end

  def terminated?
    !end_month.infinite?
  end

  def subtract(range)
    return self unless overlap?(range)

    output_range = []
    output_range << MonthRange::MRange.new(start_month, range.just_before) if cover?(range.start_month)
    output_range << MonthRange::MRange.new(range.just_after, end_month) if cover?(range.end_month) && range.terminated?
    output_range.flatten.compact
  end

  def just_before
    start_month.prev_month(1)
  end

  def just_after
    non_terminated? ? end_month : end_month.next_month(1)
  end

  private

  def valid_start_end_relation?(start_month, end_month)
    return true if end_month.nil?

    start_month <= end_month
  end
end
