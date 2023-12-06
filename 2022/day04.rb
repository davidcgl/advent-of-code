def parse(path)
  File.foreach(path).map do |line|
    if (match_data = line.match(/(\d+)-(\d+),(\d+)-(\d+)/))
      match_data[1..4].map(&:to_i).each_slice(2).to_a
    end
  end.compact
end

def contains?(range1, range2)
  range1[0] <= range2[0] && range2[1] <= range1[1]
end

def overlaps?(range1, range2)
  if range1[0] > range2[0]
    return overlaps?(range2, range1)
  end

  range1[0] <= range2[0] && range2[0] <= range1[1]
end

def part_one(path)
  pairs = parse(path)
  pairs.count do |range1, range2|
    contains?(range1, range2) || contains?(range2, range1)
  end
end

def part_two(path)
  pairs = parse(path)
  pairs.count do |range1, range2|
    overlaps?(range1, range2)
  end
end

path = File.join(__dir__, ARGV[0] || "day04.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
