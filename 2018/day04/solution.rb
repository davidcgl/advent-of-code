require 'time'

Event = Struct.new(:time, :type, :guard) do
  def self.from_line(line)
    /\[(.*)\] (.*)/.match(line) do |m|
      event = Event.new(Time.parse(m[1].sub!('1518', '2018')))
      case m[2]
      when /wakes up/
        event.type = :awake
      when /falls asleep/
        event.type = :asleep
      when /begins shift/
        event.type = :shift
        event.guard = /Guard #(\d+)/.match(m[2])[1].to_i
      end
      event
    end
  end
end

class Schedule
  attr_reader :guard

  def initialize(guard)
    @guard = guard
    @schedule = Hash.new(0)
  end

  def update(asleep_start, asleep_end)
    (asleep_start...asleep_end).each do |min|
      @schedule[min] += 1
    end
  end

  def total_asleep_minutes
    @schedule.values.sum
  end

  def max_asleep_minute
    @schedule.max_by { |_min, count| count }
  end
end

def generate_sleep_schedules(events)
  schedules = Hash.new { |hash, guard| hash[guard] = Schedule.new(guard) }
  guard = nil
  asleep = nil
  events.each do |event|
    puts "processing #{event}"
    case event.type
    when :shift
      guard = event.guard
      puts "changed guard to #{guard}"
    when :asleep
      asleep = event.time.min
      puts "changed asleep to #{asleep}"
    when :awake
      schedules[guard].update(asleep, event.time.min)
    end
  end
  schedules.values
end

File.open(File.join(__dir__, 'input.txt')) do |file|
  events = file.each.map { |line| Event.from_line(line) }.sort_by(&:time)
  schedules = generate_sleep_schedules(events)

  # Strategy 1: Find the guard that has the most minutes asleep. What minute
  # does that guard spend asleep the most?
  schedule = schedules.max_by(&:total_asleep_minutes)
  puts "Max sleeper: #{schedule.guard}"
  puts "Max asleep minute: #{schedule.max_asleep_minute}"
  puts "Answer: #{schedule.guard * schedule.max_asleep_minute[0]}"

  # Strategy 2: Of all guards, which guard is most frequently asleep on the same
  # minute?
  schedule = schedules.max_by { |s| s.max_asleep_minute.reverse }
  puts "Max sleeper: #{schedule.guard}"
  puts "Max asleep minute: #{schedule.max_asleep_minute}"
  puts "Answer: #{schedule.guard * schedule.max_asleep_minute[0]}"
end
