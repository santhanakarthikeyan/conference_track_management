require 'yaml'

class Track < Scheduler

  def initialize
    @config = get_config
    @timeTracker = get_time_by_hour(@config["START_TIME"]["hour"])
    @trackEvents = []
    preschedulable_events
  end

  def preschedulable_events
    add_event("Lunch",nil, lunch_start_time)
  end

  def has_events?(scheduled_at)
    @trackEvents.any?{|x| scheduled_at.between?(x.start_time, x.end_time)}
  end

  def find_track_end_time(scheduled_at)
    @trackEvents.select{|x| scheduled_at.between?(x.start_time, x.end_time)}.first.end_time 
  end

  def add_event(name, duration, scheduled_at = nil)
    if scheduled_at.nil? 
      @timeTracker = find_track_end_time(@timeTracker) + 1 if has_events?(@timeTracker)
      @trackEvents << Event.new(name, duration, @timeTracker)
      @timeTracker = @timeTracker + (duration * 60 )
    else
      @trackEvents << Event.new(name, duration, scheduled_at)
    end
  end

  def add_networking_event
    add_event("Networking Event",nil,@timeTracker)
  end

  def total_duration
    @trackEvents.collect{|te| te.interval}.inject(&:+).to_i
  end

  def report
    @trackEvents.sort_by{|x| x.start_time}.each{|v|
      puts v.to_s
    }
  end
end
