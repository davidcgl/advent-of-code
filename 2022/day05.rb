def parse_stacks(path)
  stacks = {}

  File.foreach(path) do |line|
    if (match_data = line.match(/(\d+): ([A-Z]+)/))
      stack_num = match_data[1].to_i
      crates = match_data[2].chars
      stacks[stack_num] = crates
    end
  end

  stacks
end

def parse_steps(path)
  File.foreach(path).map do |line|
    if (match_data = line.match(/move (\d+) from (\d+) to (\d+)/))
      match_data[1..3].map(&:to_i)
    end
  end.compact
end

def remove_crates(stacks, stack_num, num_crates)
  index = stacks[stack_num].size - num_crates
  crates = stacks[stack_num][index..]
  stacks[stack_num] = stacks[stack_num][0...index]
  crates
end

def part_one(path_crates, path_steps)
  stacks = parse_stacks(path_crates)
  steps = parse_steps(path_steps)

  steps.each do |step|
    num_crates, stack_from, stack_to = step
    crates = remove_crates(stacks, stack_from, num_crates)
    crates.reverse!
    stacks[stack_to] = stacks[stack_to].concat(crates)
  end

  stacks.values.map(&:last).join
end

def part_two(path_crates, path_steps)
  stacks = parse_stacks(path_crates)
  steps = parse_steps(path_steps)

  steps.each do |step|
    num_crates, stack_from, stack_to = step
    crates = remove_crates(stacks, stack_from, num_crates)
    stacks[stack_to] = stacks[stack_to].concat(crates)
  end

  stacks.values.map(&:last).join
end

path_crates = File.join(__dir__, ARGV[0] || "day05.input02.txt")
path_steps = File.join(__dir__, ARGV[1] || "day05.input03.txt")
puts "part one: #{part_one(path_crates, path_steps)}"
puts "part two: #{part_two(path_crates, path_steps)}"
