# frozen_string_literal: true

GRID_SIZE = 301
SERIAL = 7347

def coordinates
  Enumerator.new do |enum|
    (1...GRID_SIZE).each do |y|
      (1...GRID_SIZE).each do |x|
        enum << [y, x]
      end
    end
  end
end

def make_grid
  grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, 0) }
  coordinates.each do |y, x|
    id = x + 10
    power = id * y
    power += SERIAL
    power *= id
    power = (power / 100) % 10
    power -= 5
    grid[y][x] = power
  end
  grid
end

def find_max_power(sum_table, square_size)
  max_coordinate = []
  max_power = -Float::INFINITY
  coordinates.each do |y, x|
    max_x = x + square_size - 1
    max_y = y + square_size - 1
    next if max_x >= GRID_SIZE - 1 || max_y >= GRID_SIZE - 1

    power = sum_table[max_y][max_x] -
      sum_table[max_y][x - 1] -
      sum_table[y - 1][max_x] +
      sum_table[y - 1][x - 1]

    if max_power < power
      max_power = power
      max_coordinate = [x, y]
    end
  end
  {coordinate: max_coordinate, power: max_power}
end

def chronal_charge
  grid = make_grid

  # https://en.wikipedia.org/wiki/Summed-area_table
  # sum_table[i][j] == sum of grid[0..i][0..j]
  sum_table = Array.new(GRID_SIZE) { Array.new(GRID_SIZE, 0) }
  coordinates.each do |y, x|
    sum_table[y][x] = grid[y][x] +
      sum_table[y][x - 1] +
      sum_table[y - 1][x] -
      sum_table[y - 1][x - 1]
  end

  powers = (1...GRID_SIZE).each_with_object({}) do |square_size, hash|
    hash[square_size] = find_max_power(sum_table, square_size)
  end
  max_power = powers.max_by { |_, v| v[:power] }

  puts "max power (3x3): #{powers[3]}"
  puts "max power (any): #{max_power}"
end

chronal_charge
