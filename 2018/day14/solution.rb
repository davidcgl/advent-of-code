# frozen_string_literal: true

def plot(scores, e1, e2)
  out = scores.each_char.map { |c| " #{c} " }
  out[e1] = "(#{scores[e1]})"
  out[e2] = "[#{scores[e2]}]"
  puts out.join
end

def step
  scores = "37"
  e1 = 0
  e2 = 1
  loop do
    # plot(scores, e1, e2)
    r1 = scores[e1].to_i
    r2 = scores[e2].to_i
    scores.concat((r1 + r2).to_s)
    yield scores
    e1 = (e1 + r1 + 1) % scores.size
    e2 = (e2 + r2 + 1) % scores.size
  end
end

# What are the scores of the ten recipes immediately after the number of scores
# in your puzzle input?
def part_one(input)
  input = input.to_i
  step do |scores|
    return scores[input, 10] if input + 10 < scores.size
  end
end

# How many scores appear on the scoreboard to the left of the score sequence in
# your puzzle input?
def part_two(input)
  len = input.size
  step do |scores|
    return scores.size - len if scores[-len, len] == input
    # We could have added two recipes in the last step if they add up to >= 10.
    return scores.size - len - 1 if scores[-len - 1, len] == input
  end
end

input = "260321"
puts "part one: #{part_one(input)}"
puts "part two: #{part_two(input)}"
