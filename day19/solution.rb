# frozen_string_literal: true

OPCODES = {
  addr: ->(r, i) { r[i[1]] + r[i[2]] },
  addi: ->(r, i) { r[i[1]] + i[2] },
  mulr: ->(r, i) { r[i[1]] * r[i[2]] },
  muli: ->(r, i) { r[i[1]] * i[2] },
  banr: ->(r, i) { r[i[1]] & r[i[2]] },
  bani: ->(r, i) { r[i[1]] & i[2] },
  borr: ->(r, i) { r[i[1]] | r[i[2]] },
  bori: ->(r, i) { r[i[1]] | i[2] },
  setr: ->(r, i) { r[i[1]] },
  seti: ->(r, i) { i[1] },
  gtir: ->(r, i) { gt(i[1], r[i[2]]) },
  gtri: ->(r, i) { gt(r[i[1]], i[2]) },
  gtrr: ->(r, i) { gt(r[i[1]], r[i[2]]) },
  eqir: ->(r, i) { eq(i[1], r[i[2]]) },
  eqri: ->(r, i) { eq(r[i[1]], i[2]) },
  eqrr: ->(r, i) { eq(r[i[1]], r[i[2]]) }
}.freeze

def gt(a, b)
  a > b ? 1 : 0
end

def eq(a, b)
  a == b ? 1 : 0
end

def apply(registers, instruction)
  op = OPCODES[instruction[0]]
  registers[instruction[3]] = op.call(registers, instruction)
end

def find_target(program, reg0:)
  reg_ip, instructions = program
  registers = [reg0, 0, 0, 0, 0, 0]
  ip = 0

  while ip != 1
    registers[reg_ip] = ip
    apply(registers, instructions[ip])
    ip = registers[reg_ip] + 1
  end

  registers[2]
end

def factors(n)
  (1..Math.sqrt(n)).each_with_object([]) do |i, factors|
    factors.concat([i, n / i]) if (n % i).zero?
  end
end

def parse_program(path)
  line0, *lines = File.readlines(path)

  # Which register the instruction pointer is bound to.
  reg_ip = /#ip (\d)/.match(line0)[1].to_i

  instructions = lines.map do |line|
    opcode = /(\w+)/.match(line)[1].to_sym
    params = /(\d+) (\d+) (\d+)/.match(line).captures.map(&:to_i)
    [opcode, *params]
  end

  [reg_ip, instructions]
end

def solve
  # The program initializes a target value and then find the sum of its factors.
  # However, the sum-of-factors algorithm is inefficient (O(n^2)). Therefore, we
  # extract the target value and calculate sum-of-factors ourselves.
  #
  # Program details:
  #   Instruction 0 jumps to instruction 17
  #   Instructions 1-16 calculate the target's sum of factors
  #   Instructions 17-39 calculate the target and storer it in register 2
  program = parse_program(File.join(__dir__, ARGV[0] || 'input.txt'))

  target = find_target(program, reg0: 0)
  puts "part one: #{factors(target).sum}"

  target = find_target(program, reg0: 1)
  puts "part two: #{factors(target).sum}"
end

solve
