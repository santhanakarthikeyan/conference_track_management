require 'yaml'

class Scheduler
  include SchedulerHelper
  attr_accessor :tracks

  def initialize
    get_config
    @tracks = []
    @events = []
  end

  def validate(key,value)
    raise "Invalid event(#{key}) duration(#{value})" if key.nil? || value.nil?
  end

  def read_inputs_from_file(file_path)
    File.open(file_path).each_line{|line|
      reg_exp = line.match(/[\d]*min$|lightning$/)
      key = reg_exp.pre_match.strip
      value = reg_exp.to_s.gsub(/min|lightning/, 'min' => "", 'lightning' => "5").to_i 
      validate(key,value)
      @events << [key, value] 
    }
    @events_list = @events.dup
  end

  def total_event_duration 
    @events_list.collect{|event| event[1]}.inject(&:+)
  end

  def min_event_duration
    @events_list.collect{|event| event[1]}.min
  end
end
