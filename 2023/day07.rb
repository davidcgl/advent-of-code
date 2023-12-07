def parse(path)
  File.open(path).each_line.map do |line|
    if (match_data = line.match(/(\w+) (\d+)/))
      hand = match_data[1].chars
      bid = match_data[2].to_i
      [hand, bid]
    end
  end.compact
end

def get_hand_score(hand, has_joker:)
  tally = hand.tally

  # If "J" is considered a joker and the hand has at least one, pretend all jokers are the most
  # common card in hand. This guarantees the strongest hand based on the game's rule.
  if has_joker && tally.size > 1 && tally.has_key?("J")
    most_common_card = tally.except("J").max_by { |card, count| count }.first
    tally[most_common_card] += tally["J"]
    tally.delete("J")
  end

  # Create a pattern based which uniquely identifies the hand type. For example, a full house
  # requires three of a kind and two of a kind, so the pattern is [2, 3].
  hand_type = tally.values.sort

  case hand_type
  when [1, 1, 1, 1, 1]
    [1, :high_card]
  when [1, 1, 1, 2]
    [2, :one_pair]
  when [1, 2, 2]
    [3, :two_pairs]
  when [1, 1, 3]
    [4, :three_of_a_kind]
  when [2, 3]
    [5, :full_house]
  when [1, 4]
    [6, :four_of_a_kind]
  when [5]
    [7, :five_of_a_kind]
  else
    raise "Invalid hand and type: #{hand}, #{hand_type}"
  end
end

def get_card_score(hand, has_joker:)
  card_order = has_joker ? "J23456789TQKA" : "23456789TJQKA"
  hand.map { |card| card_order.index(card) }
end

def calculate_winnings(games, has_joker:)
  games = games.map do |hand, bid|
    hand_score = get_hand_score(hand, has_joker: has_joker)
    card_score = get_card_score(hand, has_joker: has_joker)
    [hand_score, card_score, hand, bid]
  end

  games.sort.each_with_index.sum do |game, index|
    bid = game.last
    bid * (index + 1)
  end
end

def part_one(path)
  games = parse(path)
  calculate_winnings(games, has_joker: false)
end

def part_two(path)
  games = parse(path)
  calculate_winnings(games, has_joker: true)
end

path = File.join(__dir__, ARGV[0] || "day07.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
