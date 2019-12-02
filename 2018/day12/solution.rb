# frozen_string_literal: true

require 'set'

def mutate(state, patterns)
  new_state = Set.new
  min = state.min - 3
  max = state.max + 3
  (min..max).each do |center|
    min_pot = center - 2
    max_pot = center + 2
    window = (min_pot..max_pot).map { |i| state.include?(i) ? '#' : '.' }.join
    new_state << center if patterns[window] == '#'
  end
  new_state
end

def plot(state)
  (state.min..state.max).map { |i| state.include?(i) ? '#' : '.' }.join
end

File.open(File.join(__dir__, 'input.txt')) do |file|
  # Store indexes of plants that are alive.
  initial_state = file.readline.match(/initial state: (.*)/)[1]
  initial_state = initial_state.split('').map.with_index do |plant, i|
    plant == '#' ? i : nil
  end.compact.to_set

  patterns = file.each_with_object({}) do |line, hash|
    if (m = /(.+) => (.)/.match(line))
      hash[m[1]] = m[2]
    end
  end

  state = initial_state
  20.times { state = mutate(state, patterns) }
  puts "sum after 20 generations: #{state.sum}"

  # After a few hundred iterations, the state converges to an equilibrium where
  # diff[i] = sum_alive[i] - sum_alive[i - 1] remains constant.
  state = initial_state
  sum = 0
  diff = 0
  iter = 500
  iter.times do
    state = mutate(state, patterns)
    old_sum = sum
    sum = state.sum
    diff = sum - old_sum
  end

  puts "sum after 50b generations: #{(50_000_000_000 - iter) * diff + sum}"
end
