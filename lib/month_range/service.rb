# frozen_string_literal: true

class MonthRange::Service
  # @param
  # [Date, Date]
  # [start_month, end_month]
  # @param
  # [[Date, Date], [Date, Date],]
  # [[start_month, end_month], [start_month, end_month],]
  # @return
  # [[Date, Date], [Date, Date],]
  def self.subtraction(range_array, from_range_arrays)
    collection = range_arrays_to_collection(from_range_arrays)
    start_month = range_array[0]
    end_month = range_array[1]
    m_range = MonthRange::MRange.new(start_month, end_month)
    collection.subtract(m_range)
    collection.to_a
  end

  # @param
  # [Date, Date]
  # [start_month, end_month]
  # @param
  # [[Date, Date], [Date, Date],]
  # [[start_month, end_month], [start_month, end_month],]
  # @return
  # [[Date, Date], [Date, Date],]
  def self.add(range_array, from_range_arrays)
    collection = range_arrays_to_collection(from_range_arrays)
    start_month = range_array[0]
    end_month = range_array[1]
    m_range = MonthRange::MRange.new(start_month, end_month)
    collection.add(m_range)
    collection.to_a
  end

  # @param
  # [[Date, Date], [Date, Date],]
  def self.range_arrays_to_collection(range_arrays)
    collection = MonthRange::Collection.new
    range_arrays.each do |range|
      start_month = range[0]
      end_month = range[1]
      m_range = MonthRange::MRange.new(start_month, end_month)
      collection.add(m_range)
    end
    collection
  end
end
