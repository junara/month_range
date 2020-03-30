# frozen_string_literal: true

require 'date'
require_relative '../month_range/error'

class MonthRange::MRange < Range
  class InvalidStartMonth < MonthRange::Error
  end
  class InvalidEndMonth < MonthRange::Error
  end
  class InvalidStartEndRelation < MonthRange::Error
  end

  def initialize(start_month, end_month)
    raise InvalidStartMonth, start_month unless valid_start_month?(start_month)
    raise InvalidEndMonth, end_month unless valid_end_month?(end_month)
    raise InvalidStartEndRelation, [start_month, end_month] unless valid_start_end_relation?(start_month, end_month)

    super(start_month, end_month)
  end

  def overlap?(range)
    raise "#{range} must be MRange." unless range.is_a?(MonthRange::MRange)
    return true if cover?(range.start_month)

    if range.non_terminated?
      range.start_month <= start_month
    else
      cover?(range.end_month)
    end
  end

  def start_month
    first
  end

  def end_month
    non_terminated? ? nil : last
  end

  def non_terminated?
    count == Float::INFINITY
  end

  def subtract(range)
    return self unless overlap?(range)

    output_range = []
    if cover?(range.just_before)
      output_range << MonthRange::MRange.new(start_month, range.just_before)
      output_range
    end

    if !range.non_terminated? && cover?(range.just_after)
      output_range << MonthRange::MRange.new(range.just_after, end_month)
    end
    output_range.flatten.compact
  end

  def just_before
    start_month.prev_month(1)
  end

  def just_after
    non_terminated? ? nil : end_month.next_month(1)
  end

  private

  def valid_start_month?(start_month)
    return true if start_month.is_a?(Date) && beginning_of_month?(start_month)

    false
  end

  def valid_end_month?(end_month)
    return true if end_month.nil?
    return true if end_month.is_a?(Date) && beginning_of_month?(end_month)

    false
  end

  def valid_start_end_relation?(start_month, end_month)
    return true if end_month.nil?

    start_month <= end_month
  end

  def beginning_of_month?(date)
    date.mday == 1
  end
end
