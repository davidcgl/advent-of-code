def part_one(path)
  File.foreach(path).sum do |mass|
    (mass.to_i / 3) - 2
  end
end

def part_two(path)
  File.foreach(path).sum do |mass|
    val = mass.to_i
    acc = 0
    while val > 0
      val = [0, (val / 3) - 2].max
      acc += val
    end
    acc
  end
end

path = File.join(__dir__, ARGV[0] || "input.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
