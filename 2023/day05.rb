# frozen_string_literal: true

def parse(path)
  seeds = []
  maps = []

  File.foreach(path) do |line|
    if line.match?(/seeds:/)
      seeds = line.scan(/\d+/).map(&:to_i)
    elsif line.match?(/map:/)
      maps.push([])
    elsif (match_data = line.match(/(\d+) (\d+) (\d+)/))
      dst, src, size = match_data[1..3].map(&:to_i)
      maps.last.push({src: src, dst: dst, size: size})
    end
  end

  [seeds, maps]
end

def map_value(value, map)
  entry = map.find do |entry|
    entry[:src] <= value && value < entry[:src] + entry[:size]
  end

  entry ? entry[:dst] + (value - entry[:src]) : value
end

def map_range(range, map)
  mapped_start = map_value(range[0], map)
  mapped_end = mapped_start + (range[1] - range[0])
  [mapped_start, mapped_end]
end

def divide_into_subranges(range, map)
  # Get all breakpoints from map that intersect with the range.
  breakpoints_from_map = map
    .flat_map { |entry| [entry[:src], entry[:src] + entry[:size]] }
    .select { |point| range[0] <= point && point < range[1] }

  breakpoints = [range[0], range[1]].concat(breakpoints_from_map).sort.uniq

  # Every consecutive pair forms a half-open range like [[a1, a2), [a2, a3), ..., [aN-1, aN)].
  breakpoints.each_cons(2).to_a
end

def part_one(path)
  seeds, maps = parse(path)

  locations = seeds.map do |seed|
    maps.reduce(seed) do |value, map|
      map_value(value, map)
    end
  end

  locations.min
end

def part_two(path)
  seeds, maps = parse(path)

  seed_ranges = seeds.each_slice(2).map do |seed, size|
    [seed, seed + size]
  end

  location_ranges = maps.reduce(seed_ranges) do |ranges, map|
    # For each range [A, B), divide it into consecutive subranges [[A, b1), [b1, b2), ..., [bN, B)]
    # where each subrange contains values that would be consecutive after applying the current map.
    # Then map each subrange to their destination counterparts.
    ranges
      .flat_map { |range| divide_into_subranges(range, map) }
      .map { |range| map_range(range, map) }
  end

  location_ranges.map(&:first).min
end

path = File.join(__dir__, ARGV[0] || "day05.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
