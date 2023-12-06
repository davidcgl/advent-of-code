def parse(path)
  File.foreach(path).map do |line|
    line.strip.chars
  end
end

def get_priority(item)
  if item.match?(/[a-z]/)
    item.ord - "a".ord + 1
  elsif item.match?(/[A-Z]/)
    item.ord - "A".ord + 27
  end
end

def get_common_item(*groups)
  common_items = groups.reduce do |memo, group|
    Set.new(memo) & Set.new(group)
  end
  common_items.each.next
end

def part_one(path)
  all_sacks = parse(path)
  all_sacks.sum do |sack|
    comp_size = sack.size / 2
    comp1 = sack[0...comp_size]
    comp2 = sack[comp_size...]
    get_priority(get_common_item(comp1, comp2))
  end
end

def part_two(path)
  all_sacks = parse(path)
  all_sacks.each_slice(3).sum do |sacks|
    get_priority(get_common_item(*sacks))
  end
end

path = File.join(__dir__, ARGV[0] || "day03.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
