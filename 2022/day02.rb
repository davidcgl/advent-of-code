SCORES_OUTCOME = {
  lose: 0,
  draw: 3,
  win: 6
}

SCORES_CHOICE = {
  rock: 1,
  paper: 2,
  scissors: 3
}

LETTER_TO_CHOICE = {
  A: :rock,
  B: :paper,
  C: :scissors,
  X: :rock,
  Y: :paper,
  Z: :scissors
}

LETTER_TO_OUTCOME = {
  X: :lose,
  Y: :draw,
  Z: :win
}

def get_outcome(opponent, player)
  case [opponent, player]
  when [:rock, :scissors], [:paper, :rock], [:scissors, :paper]
    :lose
  when [:rock, :rock], [:paper, :paper], [:scissors, :scissors]
    :draw
  when [:rock, :paper], [:paper, :scissors], [:scissors, :rock]
    :win
  else
    raise "Invalid opponent, player combo: #{[opponent, player]}"
  end
end

def get_player_choice(opponent, outcome)
  case [opponent, outcome]
  when [:rock, :draw], [:paper, :lose], [:scissors, :win]
    :rock
  when [:rock, :lose], [:paper, :win], [:scissors, :draw]
    :scissors
  when [:rock, :win], [:paper, :draw], [:scissors, :lose]
    :paper
  else
    raise "Invalid opponent, outcome combo: #{[opponent, outcome]}"
  end
end

def calculate_score(opponent, player)
  SCORES_CHOICE[player] + SCORES_OUTCOME[get_outcome(opponent, player)]
end

def parse(path)
  File.foreach(path).map do |line|
    if (match_data = line.match(/(A|B|C) (X|Y|Z)/))
      [match_data[1], match_data[2]].map(&:to_sym)
    end
  end.compact
end

def part_one(path)
  games = parse(path)
  games.sum do |a, b|
    opponent = LETTER_TO_CHOICE[a]
    player = LETTER_TO_CHOICE[b]
    calculate_score(opponent, player)
  end
end

def part_two(path)
  games = parse(path)
  games.sum do |a, b|
    opponent = LETTER_TO_CHOICE[a]
    outcome = LETTER_TO_OUTCOME[b]
    calculate_score(opponent, get_player_choice(opponent, outcome))
  end
end

path = File.join(__dir__, ARGV[0] || "day02.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
