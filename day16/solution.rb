# frozen_string_literal: true

RE_STATE = /(\d), (\d), (\d), (\d)/.freeze
RE_INSTR = /(\d+) (\d) (\d) (\d)/.freeze

OPCODES = {
  addr: ->(s, i) { s[i[3]] = s[i[1]] + s[i[2]] },
  addi: ->(s, i) { s[i[3]] = s[i[1]] + i[2] },
  mulr: ->(s, i) { s[i[3]] = s[i[1]] * s[i[2]] },
  muli: ->(s, i) { s[i[3]] = s[i[1]] * i[2] },
  banr: ->(s, i) { s[i[3]] = s[i[1]] & s[i[2]] },
  bani: ->(s, i) { s[i[3]] = s[i[1]] & i[2] },
  borr: ->(s, i) { s[i[3]] = s[i[1]] | s[i[2]] },
  bori: ->(s, i) { s[i[3]] = s[i[1]] | i[2] },
  setr: ->(s, i) { s[i[3]] = s[i[1]] },
  seti: ->(s, i) { s[i[3]] = i[1] },
  gtir: ->(s, i) { s[i[3]] = gt(i[1], s[i[2]]) },
  gtri: ->(s, i) { s[i[3]] = gt(s[i[1]], i[2]) },
  gtrr: ->(s, i) { s[i[3]] = gt(s[i[1]], s[i[2]]) },
  eqir: ->(s, i) { s[i[3]] = eq(i[1], s[i[2]]) },
  eqri: ->(s, i) { s[i[3]] = eq(s[i[1]], i[2]) },
  eqrr: ->(s, i) { s[i[3]] = eq(s[i[1]], s[i[2]]) }
}.freeze

def gt(a, b)
  a > b ? 1 : 0
end

def eq(a, b)
  a == b ? 1 : 0
end

def apply(op, state, instr)
  state = state.dup
  op.call(state, instr)
  state
end

def each_nonempty_line(path)
  File.open(path).map(&:strip).reject(&:empty?).each
end

def read_samples(path)
  each_nonempty_line(path).each_slice(3).map do |slice|
    {
      old: RE_STATE.match(slice[0]).captures.map(&:to_i),
      ins: RE_INSTR.match(slice[1]).captures.map(&:to_i),
      new: RE_STATE.match(slice[2]).captures.map(&:to_i)
    }
  end
end

def read_program(path)
  each_nonempty_line(path).map do |line|
    RE_INSTR.match(line).captures.map(&:to_i)
  end
end

def matching_ops(sample)
  OPCODES.select do |_, op|
    apply(op, sample[:old], sample[:ins]) == sample[:new]
  end.keys
end

def execute(instructions, num_to_ops)
  initial_state = [0, 0, 0, 0]
  instructions.reduce(initial_state) do |state, instr|
    op = OPCODES[num_to_ops[instr[0]]]
    apply(op, state, instr)
  end
end

def solve
  # For each sample <old state, instruction, new state>, find the set of opcodes
  # for which op(old state, instruction) == new state.
  samples = read_samples(File.join(__dir__, 'samples.txt'))
  matches = samples.map { |sample| [sample[:ins][0], matching_ops(sample)] }

  # How many samples in your puzzle input behave like three or more opcodes?
  count = matches.count { |_, ops| ops.size >= 3 }
  puts "part one: #{count}"

  # Deduce num => opcode mapping using process of elimination.
  num_to_ops = {}
  matches = matches.to_h
  until matches.empty?
    # We should have a 1:1 [num, [op]] mapping now, assuming that other
    # candidate ops for this num were eliminated from previous rounds.
    num, op = matches.min_by { |_, ops| ops.size }.flatten
    num_to_ops[num] = op
    matches.delete(num)
    matches.each { |_, ops| ops.delete(op) }
  end

  # What value is contained in register 0 after executing the test program?
  instructions = read_program(File.join(__dir__, 'program.txt'))
  final_state = execute(instructions, num_to_ops)
  puts "part two: #{final_state[0]}"
end

solve
