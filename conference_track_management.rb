require_relative "scheduler_helper"
require_relative "scheduler"
require_relative "track"
require_relative "event"

#parse the inputs
scheduler = Scheduler.new
scheduler.read_inputs_from_file("input_events.txt")

raise "Not enough events avaiable to host the conference" if !scheduler.valid_total_event_dutaion?

#pick possible events and start scheduling per day wise
1.upto(scheduler.max_track_length) do |index|
  track = Track.new
  scheduler.explore_possible_events(track, scheduler.morning_session_duration)
  scheduler.explore_possible_events(track, scheduler.afternoon_session_duration, scheduler.avg_track_duration, 60)
  track.add_networking_event
  scheduler.tracks << track
end

#show the scheduled report
scheduler.tracks.each_with_index{|track,index| 
  puts "\nTrack #{index + 1}:"
  track.report
}
