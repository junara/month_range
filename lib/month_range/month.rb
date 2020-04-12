# frozen_string_literal: true

require 'date'
require_relative '../month_range/error'

class MonthRange::Month < Date
  class InvalidMonthFormat < MonthRange::Error
  end

  def self.create(date)
    return MonthRange::Month::Infinity.new if date.nil?
    raise InvalidMonthFormat unless date.is_a?(Date)
    raise InvalidMonthFormat unless date.mday == 1

    new(date.year, date.month, date.mday)
  end

  def to_date
    Date.new(year, month, mday)
  end

  class Infinity < Numeric
    def infinite?
      true
    end

    def <=(other)
      other.infinite?
    end

    def >=(other)
      other.infinite? ? true : other.is_a?(MonthRange::Month)
    end

    def ==(other)
      other.infinite?
    end

    def to_date
      nil
    end

    def <=>(other)
      case other
      when Infinity
        return 1
      when MonthRange::Month
        return 1
      end
      nil
    end

    def to_f
      Float::INFINITY
    end
  end
end
