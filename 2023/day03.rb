def parse_grid(path)
  File.readlines(path, chomp: true).map(&:chars)
end

def digit?(grid, x, y)
  grid[x][y].match?(/[0-9]/)
end

def blank?(grid, x, y)
  grid[x][y] == "."
end

def gear?(grid, x, y)
  grid[x][y] == "*"
end

def symbol?(grid, x, y)
  !blank?(grid, x, y) && !digit?(grid, x, y)
end

def inbound?(grid, x, y)
  num_rows = grid.size
  num_cols = grid[0].size
  x >= 0 && x < num_rows && y >= 0 && y < num_cols
end

def get_parts(grid)
  num_rows = grid.size
  num_cols = grid[0].size

  part = nil
  parts = []

  num_rows.times do |x|
    num_cols.times do |y|
      if digit?(grid, x, y)
        if part.nil?
          part = {num: 0, start_x: x, start_y: y, size: 0}
        end
        part[:num] = part[:num] * 10 + grid[x][y].to_i
        part[:size] += 1
      elsif part
        parts << part
        part = nil
      end
    end
  end

  parts
end

def get_coordinates_of_adjacent_symbols(grid, part)
  symbols = []

  (part[:start_x] - 1).upto(part[:start_x] + 1).each do |x|
    (part[:start_y] - 1).upto(part[:start_y] + part[:size]).each do |y|
      if inbound?(grid, x, y) && symbol?(grid, x, y)
        symbols << [x, y]
      end
    end
  end

  symbols
end

def part_one(path)
  grid = parse_grid(path)
  parts = get_parts(grid)
  parts
    .select { |part| get_coordinates_of_adjacent_symbols(grid, part).size > 0 }
    .sum { |part| part[:num] }
end

def part_two(path)
  grid = parse_grid(path)
  parts = get_parts(grid)

  # Create a map where the keys are coordinate of symbols, and values are parts that are adjacent
  # to the symbol. Each part may be adjacent to more than one symbols.
  parts_by_symbols = Hash.new { |hash, key| hash[key] = [] }
  parts.each do |part|
    get_coordinates_of_adjacent_symbols(grid, part).each do |symbol|
      parts_by_symbols[symbol] << part
    end
  end

  # A gear is any * symbol that is adjacent to exactly two part numbers. Its gear ratio is the result
  # of multiplying those two numbers together. This time, you need to find the gear ratio of every
  # gear and add them all up so that the engineer can figure out which gear needs to be replaced.
  parts_by_symbols
    .select { |(x, y), parts| gear?(grid, x, y) && parts.size == 2 }
    .sum { |_, parts| parts[0][:num] * parts[1][:num] }
end

path = File.join(__dir__, ARGV[0] || "day03.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
