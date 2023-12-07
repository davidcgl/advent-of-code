def find_marker(path, window_size)
  count = ("a".."z").map { |c| [c, 0] }.to_h
  window = []
  num_unique = 0

  File.open(path).each_char.with_index do |c, index|
    window << c
    count[c] += 1
    if count[c] == 1
      num_unique += 1
    end

    if window.size > window_size
      char = window.shift
      count[char] -= 1
      if count[char] == 0
        num_unique -= 1
      end
    end

    if num_unique == window_size
      return index + 1
    end
  end

  nil
end

def part_one(path)
  find_marker(path, 4)
end

def part_two(path)
  find_marker(path, 14)
end

path = File.join(__dir__, ARGV[0] || "day06.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
