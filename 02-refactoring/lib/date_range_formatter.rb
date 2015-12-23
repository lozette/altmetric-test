require "date"
require "fixnum"

class DateRangeFormatter
  def initialize(start_date, end_date, start_time = nil, end_time = nil)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @start_time = start_time
    @end_time = end_time
  end

  def to_s
    [full_start_date, start_time, full_end_date, end_time].join(' ').squeeze(' ').strip
  end

  private

  def full_start_date
    # This is the really horrible bit, struggling to make it simpler
    return @start_date.strftime("#{@start_date.day.ordinalize} %B %Y") if same_day
    return @start_date.strftime("#{@start_date.day.ordinalize} %B %Y") if times_present

    if same_month && same_year
      @start_date.strftime("#{@start_date.day.ordinalize}")
    elsif same_year
      @start_date.strftime("#{@start_date.day.ordinalize} %B")
    else
      @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
    end
  end

  def full_end_date
    return if same_day
    
    "- #{@end_date.strftime("#{@end_date.day.ordinalize} %B %Y")}"
  end

  def start_time
    return unless @start_time

    "at #{@start_time}"
  end

  def end_time
    return unless @end_time

    if same_day
      "to #{@end_time}"
    elsif @end_date || @start_date
      "at #{@end_time}"
    else
      "until #{@end_time}"
    end
  end

  def same_day
    return true if @start_date == @end_date
    false
  end

  def same_month
    return true if @start_date.month == @end_date.month
    false
  end

  def same_year
    return true if @start_date.year == @end_date.year
    false
  end

  def times_present
    return true if @start_time || @end_time
    false
  end
end

