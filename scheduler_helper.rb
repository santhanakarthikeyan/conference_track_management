module SchedulerHelper
  
  def explore_possible_events track, timeDuration, avgDuration=1440, threshold=0
    #avgDuration - max allowed durations per day
    #threshold - network event duration
    #timeDuration - max allowed duration per session
    while(true)
      pEvents = []
      sumDuration = 0
      #filter possible events
      @events.each{|event|
	if (track.total_duration + sumDuration + event[1]) > avgDuration
	  next
       	elsif (sumDuration + event[1]).eql?(timeDuration)
	  sumDuration += event[1]
	  pEvents << event 
	  break
       	elsif (sumDuration + event[1]) < timeDuration 
	  sumDuration += event[1]
	  pEvents << event 
       	end
      }
      #check filtered events are matching the conditions
      if sumDuration.between?(timeDuration - threshold, timeDuration) 
	#if does then prepare the event list 
       	pEvents.each{|x|
	  track.add_event x[0], x[1] 
       	}
       	@events = @events - pEvents
       	break
      else
	#if not then shuffle and continue the iteration
	  @events.shuffle!
	  sleep 2
      end
    end
  end

  def get_config
    @config = YAML.load_file("configuration.yaml")
  end

  def get_time_by_hour(hour)
    today = Time.now
    Time.new(today.year, today.month, today.day, hour)
  end

  def lunch_start_time
    get_time_by_hour(@config["LUNCH_BREAK"]["start_time"]["hour"])
  end

  def lunch_end_time
    get_time_by_hour(@config["LUNCH_BREAK"]["end_time"]["hour"])
  end

  def track_start_time
    get_time_by_hour(@config["START_TIME"]["hour"])
  end

  def track_end_time
    get_time_by_hour(@config["END_TIME"]["hour"])
  end

  def morning_session_duration
    ( ( lunch_start_time - track_start_time ) / 60 ).to_i
  end

  def afternoon_session_duration
    ( ( track_end_time - lunch_end_time ) / 60 ).to_i
  end

  def max_track_duration
    morning_session_duration + afternoon_session_duration
  end

  def min_track_duration
    max_track_duration - 60
  end

  def avg_track_duration
    (total_event_duration / max_track_length) + min_event_duration
  end

  def max_track_length
    [total_event_duration / min_track_duration , total_event_duration / max_track_duration].max
  end

  def valid_total_event_dutaion?
    total_event_duration.between?(min_track_duration * max_track_length , max_track_duration * max_track_length)
  end

end
