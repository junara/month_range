# frozen_string_literal: true

require 'date'

class MonthRange::MRange < Range
  class InvalidStartMonth < MonthRange::Error
  end
  class InvalidEndMonth < MonthRange::Error
  end

  def initialize(start_month, end_month)
    raise InvalidStartMonth, start_month unless valid_start_month?(start_month)
    raise InvalidEndMonth, end_month unless valid_end_month?(end_month)

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

  def beginning_of_month?(date)
    date.mday == 1
  end
end
