class Event
  
  attr_accessor :name, :interval, :start_time, :end_time

  def initialize name=nil, interval=nil, scheduled_at = nil
    @name = name
    @interval = interval.to_i
    @start_time = scheduled_at 
    @end_time = @interval.zero? ? (scheduled_at + (60 * 60) - 1) : (scheduled_at + (@interval * 60) - 1)
  end

  def to_s
    @interval.zero? ? "#{@start_time.strftime("%H:%M %p")} #@name" : "#{@start_time.strftime("%H:%M %p")} #@name #{@interval}min"
  end

end

