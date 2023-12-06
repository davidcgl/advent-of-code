NUMERAL = {
  "0" => 0,
  "1" => 1,
  "2" => 2,
  "3" => 3,
  "4" => 4,
  "5" => 5,
  "6" => 6,
  "7" => 7,
  "8" => 8,
  "9" => 9
}

ENGLISH = {
  "zero" => 0,
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

def find_digit1(line, digit_map)
  min_key, _ = digit_map.keys.map { |k| [k, line.index(k) || line.size] }.min_by(&:last)
  digit_map[min_key]
end

def find_digit2(line, digit_map)
  max_key, _ = digit_map.keys.map { |k| [k, line.rindex(k) || -1] }.max_by(&:last)
  digit_map[max_key]
end

def find_sum(path, digit_map)
  File.foreach(path).sum do |line|
    digit1 = find_digit1(line, digit_map)
    digit2 = find_digit2(line, digit_map)
    (digit1 * 10) + digit2
  end
end

def part_one(path)
  find_sum(path, NUMERAL)
end

def part_two(path)
  find_sum(path, NUMERAL.merge(ENGLISH))
end

path = File.join(__dir__, ARGV[0] || "day01.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
