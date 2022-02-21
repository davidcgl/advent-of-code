# frozen_string_literal: true

def part_one(path)
  lines = File.readlines(path).map(&:to_i)
  lines.each_cons(2).sum { |prev, curr| prev < curr ? 1 : 0 }
end

def part_two(path)
  lines = File.readlines(path).map(&:to_i)
  lines.each_cons(3).map(&:sum).each_cons(2).sum { |prev, curr| prev < curr ? 1 : 0 }
end

path = File.join(__dir__, ARGV[0] || "input.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
