def parse(path)
  all_calories = []
  cur_calories = 0

  File.foreach(path) do |line|
    if (match_data = line.match(/\d+/))
      cur_calories += match_data[0].to_i
    elsif line.strip.empty?
      all_calories << cur_calories
      cur_calories = 0
    end
  end

  all_calories
end

def part_one(path)
  calories = parse(path)
  calories.max
end

def part_two(path)
  calories = parse(path)
  calories.max(3).sum
end

path = File.join(__dir__, ARGV[0] || "day01.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
