def plot(grid, carts)
  out = ""
  grid.keys.group_by(&:first).values.each_with_index do |cells, i|
    out += "#{i.to_s.rjust(3)} "
    out += cells.map { |pos| carts.dig(pos, :dir) || grid[pos] }.join
    out += "\n"
  end
  puts out
end

def solve(grid, carts)
  # How to move in each direction.
  directions = {
    "^" => [-1, 0],
    "v" => [1, 0],
    "<" => [0, -1],
    ">" => [0, 1]
  }

  # For each direction, how to turn left, straight, and right.
  crossroads = {
    "^" => ["<", "^", ">"],
    "v" => [">", "v", "<"],
    "<" => ["v", "<", "^"],
    ">" => ["^", ">", "v"]
  }

  # How to turn at a forward slash (/) and backslash (\).
  fturns = {"^" => ">", "v" => "<", "<" => "v", ">" => "^"}
  bturns = {"^" => "<", "v" => ">", "<" => "^", ">" => "v"}

  # [y, x] coordinate of the first crash.
  first_crash = nil

  while carts.size > 1
    # plot(grid, carts)

    # Process carts in increasing order of [y, x] coordinates.
    carts.keys.sort.each do |pos|
      # If cart is nil, it must have been removed due to a crash.
      cart = carts[pos]
      next unless cart

      track = grid[pos]
      case track
      when "+"
        cart[:dir] = crossroads[cart[:dir]][cart[:turn].next]
      when "/"
        cart[:dir] = fturns[cart[:dir]]
      when "\\"
        cart[:dir] = bturns[cart[:dir]]
      end

      new_pos = [
        pos[0] + directions[cart[:dir]][0],
        pos[1] + directions[cart[:dir]][1]
      ]

      # Will there be a crash?
      if carts.key?(new_pos)
        first_crash = new_pos if first_crash.nil?
        carts.delete(pos)
        carts.delete(new_pos)
      else
        carts[new_pos] = carts.delete(pos)
      end
    end
  end

  last_cart = carts.shift[0] if carts.any?
  puts "first crash: #{first_crash.reverse}"
  puts "  last cart: #{last_cart.reverse}"
end

File.open(File.join(__dir__, "input.txt")) do |file|
  carts = {}
  grid = {}

  file.readlines.each_with_index do |line, y|
    line.rstrip.each_char.with_index do |char, x|
      pos = [y, x]
      if ["^", "v", "<", ">"].include?(char)
        carts[pos] = {dir: char, turn: [0, 1, 2].cycle}
        grid[pos] = ["^", "v"].include?(char) ? "|" : "-"
      else
        grid[pos] = char
      end
    end
  end

  solve(grid, carts)
end
