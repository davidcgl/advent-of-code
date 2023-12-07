def parse_part_one(path)
  lines = File.readlines(path)
  times = lines[0].scan(/\d+/).map(&:to_i)
  distances = lines[1].scan(/\d+/).map(&:to_i)
  times.zip(distances)
end

def parse_part_two(path)
  lines = File.readlines(path)
  time = lines[0].scan(/\d+/).join.to_i
  distance = lines[1].scan(/\d+/).join.to_i
  [time, distance]
end

def count_ways_to_win(race)
  # Let:
  #
  #   T = total time
  #   D = distance to win
  #   x = holding time = speed
  #
  # Therefore:
  #
  #      traveling time = total time - holding time = T - x
  #   distance traveled = traveling time * speed = (T - x) * x
  #
  # We want to find all values of x where:
  #
  #   distance traveled > distance to win
  #         (T - x) * x > D
  #         Tx + (-x^2) > D
  #     Tx + (-x^2) - D > 0
  #     -(x^2) + Tx - D > 0
  #
  # The LHS is a quadratic function ax^2 + bx + c, where a = -1, b = T, c = -D. Therefore we can use
  # the quadratic formula to find two roots x1 and x2 that satisfies the equation.
  #
  # Since this function creates a parabola (U-shaped curve), all values of x between x1 and x2 must
  # give us a value greater than 0. Therefore all integers between x1 and x2 are valid holding times
  # that satisfies distance traveled > distance to win.

  time, distance = race

  a = -1.0
  b = time.to_f
  c = -1.0 * distance

  x1 = ((-b) - Math.sqrt(b**2 - (4 * a * c))) / (2 * a)
  x2 = ((-b) + Math.sqrt(b**2 - (4 * a * c))) / (2 * a)

  num1 = [x1, x2].min.ceil
  num2 = [x1, x2].max.floor
  num2 - num1 + 1
end

def part_one(path)
  races = parse_part_one(path)
  races.reduce(1) do |product, race|
    product * count_ways_to_win(race)
  end
end

def part_two(path)
  race = parse_part_two(path)
  count_ways_to_win(race)
end

path = File.join(__dir__, ARGV[0] || "day06.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
