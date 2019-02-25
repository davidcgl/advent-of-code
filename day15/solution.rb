# frozen_string_literal: true

require 'algorithms'
require 'set'

class Game
  def initialize(lines, elf_damage)
    @len_y = lines.size
    @len_x = lines[0].size
    @units = []
    @grid = {}
    @len_y.times do |y|
      @len_x.times do |x|
        pos = [y, x]
        char = lines[pos[0]][pos[1]]
        case char
        when '.', '#'
          @grid[pos] = char
        when 'E', 'G'
          @grid[pos] = '.'
          damage = char == 'E' ? elf_damage : 3
          @units << Unit.new(type: char, pos: pos, damage: damage)
        end
      end
    end
  end

  def ended?
    @units.select(&:alive?).map(&:type).uniq.size == 1
  end

  def total_remaining_hp
    @units.select(&:alive?).sum(&:hp)
  end

  def step
    complete = true
    @units.sort_by(&:pos).each do |unit|
      # This unit was just killed in the current round.
      next unless unit.alive?

      # Game ended without completing the current round.
      if ended?
        complete = false
        break
      end

      # If there is an adjacent enemy, attack and end the turn.
      if (enemy = find_adjacent_enemy(unit))
        unit.attack(enemy)
        next
      end

      # Find the closest cell adjacent to an enemy that is reachable.
      paths = shortest_paths(unit.pos, find_destinations(unit))
      next if paths.empty?

      # Move towards that cell.
      unit.move(paths.map { |path| path[1] }.min)

      # Is there any adjacent enemy after moving?
      if (enemy = find_adjacent_enemy(unit))
        unit.attack(enemy)
      end
    end

    @units.select!(&:alive?)
    complete
  end

  # Returns an adjacent enemy with the lowest HP and in reading order.
  def find_adjacent_enemy(unit)
    neighbors(unit.pos)
      .map    { |p| @units.find { |u| u.pos == p } }
      .select { |u| u && u.alive? && u.type != unit.type }
      .min_by { |u| [u.hp, u.pos] }
  end

  # Returns all unoccupied cells adjacent to any enemy units.
  def find_destinations(unit)
    @units
      .select   { |u| u.alive? && u.type != unit.type }
      .flat_map { |u| neighbors(u.pos).to_a }
      .reject   { |p| occupied?(p) }
  end

  # Returns the shortest path from src to one of the destinations. If there are
  # multiple shortest paths, e.g. A->B has the same length as A->C, returns
  # all of them.
  def shortest_paths(src, destinations)
    return [] if destinations.empty?

    paths = []
    visited = Set.new([src])
    queue = Containers::MinHeap.new
    queue.push([1, [src]])

    until queue.empty?
      _, path = queue.pop

      # Not going to find shorter paths than current best, return.
      break if paths.any? && paths[0].size < path.size

      cur = path.last
      paths << path if destinations.include?(cur)

      neighbors(cur).each do |pos|
        next if visited.include?(pos) || occupied?(pos)

        visited.add(pos)
        new_path = Array.new(path.size) { |i| path[i].dup }
        new_path << pos
        queue.push([new_path.size, new_path])
      end
    end

    paths
  end

  def to_s
    out = []
    units = @units.each_with_object({}) do |unit, hash|
      hash[unit.pos] = unit
    end

    @len_y.times do |y|
      out << []
      @len_x.times do |x|
        pos = [y, x]
        unit = units[pos]
        out.last << (unit ? unit.type : @grid[pos])
      end
      row_units = @units.select { |u| u.pos[0] == y }.sort_by(&:pos)
      out.last << '  ' << row_units.join(', ')
    end
    out.map(&:join).join("\n")
  end

  private

  def neighbors(pos)
    Enumerator.new do |enum|
      [[-1, 0], [0, -1], [0, 1], [1, 0]].each do |y, x|
        enum << [pos[0] + y, pos[1] + x]
      end
    end
  end

  def valid?(pos)
    y, x = *pos
    y >= 0 && y < @len_y && x >= 0 && x < @len_x
  end

  def occupied?(pos)
    @grid[pos] == '#' || @units.any? { |u| u.alive? && u.pos == pos }
  end
end

class Unit
  attr_accessor :type, :hp, :damage, :pos

  def initialize(type:, damage:, pos:)
    @type = type
    @damage = damage
    @pos = pos
    @hp = 200
  end

  def attack(other)
    other.hp -= damage
  end

  def move(pos)
    self.pos = pos
  end

  def alive?
    hp.positive?
  end

  def to_s
    "#{type}(#{hp})"
  end
end

def play(lines, elf_damage)
  game = Game.new(lines, elf_damage)
  rounds = 0
  until game.ended?
    rounds += 1 if game.step
    puts "After #{rounds} rounds"
    puts game
  end
  total_remaining_hp = game.total_remaining_hp

  puts "\n============================================="
  puts "  elf damage: #{elf_damage}"
  puts "      rounds: #{rounds}"
  puts "remaining hp: #{total_remaining_hp}"
  puts "     outcome: #{rounds * total_remaining_hp}"
  puts "=============================================\n"
end

filename = ARGV[0] || 'input.txt'
File.open(File.join(__dir__, filename)) do |file|
  lines = file.readlines.map(&:rstrip)
  play(lines, 3)
  play(lines, 16)
end
