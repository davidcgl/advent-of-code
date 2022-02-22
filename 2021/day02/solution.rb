# frozen_string_literal: true

def part_one(path)
  depth = 0
  width = 0

  File.foreach(path) do |line|
    tokens = line.split(" ")
    direction = tokens[0]
    magnitude = tokens[1].to_i

    case direction
    when "forward"
      width += magnitude
    when "down"
      depth += magnitude
    when "up"
      depth -= magnitude
    else
      raise "Invalid line: #{tokens}"
    end
  end

  depth * width
end

def part_two(path)
  depth = 0
  width = 0
  aim = 0

  File.foreach(path) do |line|
    tokens = line.split(" ")
    direction = tokens[0]
    magnitude = tokens[1].to_i

    case direction
    when "forward"
      width += magnitude
      depth += (magnitude * aim) if aim > 0
    when "down"
      aim += magnitude
    when "up"
      aim -= magnitude
    else
      raise "Invalid line: #{tokens}"
    end
  end

  depth * width
end

path = File.join(__dir__, ARGV[0] || "input.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
