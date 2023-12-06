# Parse game description like this
#   "Game 4: 3 red, 4 green; 5 red, 1 blue; 2 green; 3 green, 1 blue; 2 green, 1 blue, 1 red"
# into this
#   {
#     id: "4",
#     combos: [
#       {red: 3, green: 4, blue: 0},
#       {red: 5, green: 0, blue: 1},
#       {red: 0, green: 2, blue: 0},
#       {red: 0, green: 3, blue: 1},
#       {red: 1, green: 2, blue: 1},
#     ],
#   }
def parse_game(description)
  match_data = description.match(/Game (\d+):/)
  game_id = match_data[1]

  game_combos = description[(match_data.end(0)..)].split(";").map(&:strip)
  game_combos.map! do |combo|
    [:red, :green, :blue].each_with_object({}) do |color, memo|
      memo[color] = count_cubes_with_color(combo, color)
    end
  end

  {id: game_id, combos: game_combos}
end

def count_cubes_with_color(combo, color)
  match_data = combo.match(/(\d+) #{color}/)
  match_data ? match_data[1].to_i : 0
end

def valid_game?(game, max_red, max_green, max_blue)
  game[:combos].all? do |combo|
    combo[:red] <= max_red && combo[:green] <= max_green && combo[:blue] <= max_blue
  end
end

def calculate_power(game)
  [:red, :green, :blue].reduce(1) do |power, color|
    min_cubes_required = game[:combos].map { |combo| combo[color] }.max
    min_cubes_required * power
  end
end

def part_one(path)
  File.foreach(path).sum do |line|
    game = parse_game(line)
    valid_game?(game, 12, 13, 14) ? game[:id].to_i : 0
  end
end

def part_two(path)
  File.foreach(path).sum do |line|
    game = parse_game(line)
    calculate_power(game)
  end
end

path = File.join(__dir__, ARGV[0] || "day02.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
