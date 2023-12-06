class Landscape
  def initialize(path)
    @trees = Set.new
    @yards = Set.new

    lines = File.readlines(path).map(&:strip)
    lines.each_with_index do |line, y|
      line.split("").each_with_index do |cell, x|
        if cell == "#"
          @yards << [x, y]
        elsif cell == "|"
          @trees << [x, y]
        end
      end
    end

    @rows = lines.size
    @cols = lines[0].size
  end

  def tick
    new_trees = generate_trees
    new_yards = generate_yards
    @trees = (@trees | new_trees) - new_yards
    @yards = new_yards
  end

  def resource
    @trees.size * @yards.size
  end

  def digest
    [@trees, @yards, @rows, @cols].hash
  end

  def to_s
    out = []
    @rows.times do |y|
      @cols.times do |x|
        out << val(x, y)
      end
      out << "\n"
    end
    out.join
  end

  private

  def generate_trees
    # An open acre becomes filled with trees if it is adjacent to three or more
    # acres of trees.
    adj_trees = @trees.each_with_object(Hash.new(0)) do |tree, hash|
      adjacent(tree)
        .reject { |adj| @trees.include?(adj) || @yards.include?(adj) }
        .each { |adj| hash[adj] += 1 }
    end
    Set.new(adj_trees.select { |_, count| count >= 3 }.keys)
  end

  def generate_yards
    yards = Set.new

    # An acre of trees becomes a lumberyard if three or more adjacent
    # acres were lumberyards.
    @trees.each do |tree|
      num_adj_yards = adjacent(tree).count { |adj| @yards.include?(adj) }
      yards << tree if num_adj_yards >= 3
    end

    # An acre containing lumberyard remains a lumberyard if it was adjacent to
    # at least one other lumberyard and at least one acre of trees.
    @yards.each do |yard|
      has_adj_yard = adjacent(yard).any? { |adj| @yards.include?(adj) }
      has_adj_tree = adjacent(yard).any? { |adj| @trees.include?(adj) }
      yards << yard if has_adj_yard && has_adj_tree
    end

    yards
  end

  def adjacent(coordinate)
    Enumerator.new do |enum|
      offsets =
        [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]
      offsets.each do |i, j|
        x = coordinate[0] + i
        y = coordinate[1] + j
        enum << [x, y] if valid(x, y)
      end
    end
  end

  def val(x, y)
    if @yards.include?([x, y]) && @trees.include?([x, y])
      "$"
    elsif @yards.include?([x, y])
      "#"
    elsif @trees.include?([x, y])
      "|"
    else
      "."
    end
  end

  def valid(x, y)
    x >= 0 && x < @cols && y >= 0 && y < @rows
  end
end

def solve(path, limit:)
  landscape = Landscape.new(path)
  resources = Hash.new(0)
  digests = []

  limit.times do
    landscape.tick
    digest = landscape.digest

    if resources.key?(digest)
      start = digests.index(digest)
      digests = digests[start, digestes.size - start]
      limit -= start
      break
    end

    resources[digest] = landscape.resource
    digests << digest
  end

  resources[digests[(limit - 1) % digests.size]]
end

path = File.join(__dir__, ARGV[0] || "input.txt")
puts "part one: #{solve(path, limit: 10)}"
puts "part two: #{solve(path, limit: 1_000_000_000)}"
