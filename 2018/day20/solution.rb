def explore(tokens)
  directions = {"N" => [0, -1], "W" => [-1, 0], "S" => [0, 1], "E" => [1, 0]}
  checkpoints = []
  min_distances = Hash.new(Float::INFINITY)

  pos = [0, 0]
  distance = 0

  tokens.each do |token|
    case token
    when "N", "W", "S", "E"
      dir = directions[token]
      pos = [pos[0] + dir[0], pos[1] + dir[1]]
      distance += 1
      min_distances[pos] = [min_distances[pos], distance].min
    when "("
      checkpoints.push([pos, distance])
    when ")"
      pos, distance = checkpoints.pop
    when "|"
      pos, distance = checkpoints.last
    when "^", "$"
      next
    else
      raise "Unknown token: #{token}"
    end
  end

  min_distances
end

def solve(path)
  tokens = File.read(path).strip.split("")
  distances = explore(tokens).values
  puts "part one: #{distances.max}"
  puts "part two: #{distances.count { |d| d >= 1000 }}"
end

solve(File.join(__dir__, ARGV[0] || "input.txt"))
