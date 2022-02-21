# frozen_string_literal: true

require "set"

class Reservoir
  def initialize(clays, spring = [500, 0])
    @clays = clays
    @spring = spring
    @min_x = clays.map(&:first).min
    @max_x = clays.map(&:first).max
    @min_y = clays.map(&:last).min
    @max_y = clays.map(&:last).max
    @flows = Set.new
    @still = Set.new
    @visited = Set.new
    @stack = []
    simulate
  end

  def count_all
    # Ignore tiles with a y coordinate smaller than the smallest y coordinate in
    # your scan data or larger than the largest one. Any x coordinate is valid.
    flows = @flows.select { |_, y| y >= @min_y && y <= @max_y }
    (@still | flows).size
  end

  def count_still
    @still.size
  end

  def to_s
    out = []
    (@min_y..@max_y).each do |y|
      ((@min_x - 1)..(@max_x + 1)).each do |x|
        out <<
          if @spring == [x, y]
            "+"
          elsif @still.include?([x, y])
            "~"
          elsif @flows.include?([x, y])
            "|"
          elsif @clays.include?([x, y])
            "#"
          else
            "."
          end
      end
      out << "\n"
    end
    out.join
  end

  private

  def simulate
    schedule(:fall, @spring[0], @spring[1] + 1)
    while @stack.any?
      method_name, x, y = @stack.pop
      send(method_name, x, y)
    end
  end

  def fall(x, y)
    while y <= @max_y && !pile?(x, y + 1)
      @flows << [x, y]
      y += 1
    end
    schedule(:scan, x, y) if pile?(x, y + 1)
  end

  def scan(x, y)
    min_x = x
    min_x -= 1 while !clay?(min_x - 1, y) && pile?(min_x - 1, y + 1)
    max_x = x
    max_x += 1 while !clay?(max_x + 1, y) && pile?(max_x + 1, y + 1)
    if clay?(min_x - 1, y) && clay?(max_x + 1, y)
      @still |= (min_x..max_x).map { |x| [x, y] }
      schedule(:scan, x, y - 1)
    else
      @flows |= (min_x..max_x).map { |x| [x, y] }
      schedule(:fall, min_x - 1, y) unless clay?(min_x - 1, y)
      schedule(:fall, max_x + 1, y) unless clay?(max_x + 1, y)
    end
  end

  def pile?(x, y)
    @clays.include?([x, y]) || @still.include?([x, y])
  end

  def clay?(x, y)
    @clays.include?([x, y])
  end

  def schedule(method_name, x, y)
    task = [method_name, x, y]
    @stack << task if @visited.add?(task)
  end
end

filename = ARGV[0] || "input.txt"
File.open(File.join(__dir__, filename)) do |file|
  clays = file.each_with_object(Set.new) do |line, set|
    a, b1, b2 = line.scan(/\d+/).map(&:to_i)
    (b1..b2).each do |b|
      set << (line[0] == "x" ? [a, b] : [b, a])
    end
  end

  reservoir = Reservoir.new(clays)
  puts "part one: #{reservoir.count_all}"
  puts "part two: #{reservoir.count_still}"
end
