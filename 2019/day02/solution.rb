def run(program)
  i = 0

  loop do
    opcode = program[i]
    if opcode == 1
      op1, op2, res = program[(i + 1)..(i + 3)]
      program[res] = program[op1] + program[op2]
      i += 4
    elsif opcode == 2
      op1, op2, res = program[(i + 1)..(i + 3)]
      program[res] = program[op1] * program[op2]
      i += 4
    elsif opcode == 99
      break
    end
  end

  program[0]
end

def part_one(path)
  program = File.read(path).split(",").map(&:to_i)
  program[1] = 12
  program[2] = 2
  run(program)
end

def part_two(path)
  source = File.read(path).split(",").map(&:to_i)
  target = 19_690_720

  100.times do |noun|
    100.times do |verb|
      program = source.clone
      program[1] = noun
      program[2] = verb
      return 100 * noun + verb if run(program) == target
    end
  end

  nil
end

path = File.join(__dir__, ARGV[0] || "input.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
