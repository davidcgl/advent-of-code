# frozen_string_literal: true

def parse_card(line)
  match_data = line.match(/Card\W+(\d+):/)
  card_id = match_data[1]

  numbers = line[match_data.end(0)..].split("|")
  numbers.map! do |numbers|
    numbers.strip.split(/\W+/)
  end

  {id: card_id, winning_numbers: numbers[0], chosen_numbers: numbers[1]}
end

def get_num_matches(card)
  (Set.new(card[:winning_numbers]) & Set.new(card[:chosen_numbers])).size
end

def part_one(path)
  File.foreach(path).sum do |line|
    card = parse_card(line)
    num_matches = get_num_matches(card)
    (num_matches > 0) ? 2**(num_matches - 1) : 0
  end
end

def part_two(path)
  num_copies_by_card = Hash.new { |hash, key| hash[key] = 1 }

  File.foreach(path) do |line|
    card = parse_card(line)
    num_copies = num_copies_by_card[card[:id]]
    num_matches = get_num_matches(card)

    num_matches.times do |i|
      next_card_id = (card[:id].to_i + i + 1).to_s
      num_copies_by_card[next_card_id] += num_copies
    end
  end

  num_copies_by_card.values.sum
end

path = File.join(__dir__, ARGV[0] || "day04.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
