# frozen_string_literal: true

require "set"

# Represents a bounding box.
Box = Struct.new(:id, :x, :y, :width, :height) do
  def self.from_line(line)
    /#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/.match(line) do |match|
      Box.new(*match.captures.map(&:to_i))
    end
  end

  def each_square
    (x...x + width).each do |i|
      (y...y + height).each do |j|
        yield [i, j]
      end
    end
  end

  def overlap?(other)
    (x < other.x + other.width) && (other.x < x + width) &&
      (y < other.y + other.height) && (other.y < y + height)
  end
end

def squares_with_multiple_claims(boxes)
  seen = Set.new
  dups = Set.new
  boxes.each do |box|
    box.each_square do |cell|
      dups.add(cell) if seen.add?(cell).nil?
    end
  end
  dups.size
end

def box_without_overlap(boxes)
  count = Hash.new(0)
  boxes.combination(2) do |box1, box2|
    if box1.overlap?(box2)
      count[box1] += 1
      count[box2] += 1
    end
  end
  boxes.find { |box| count[box].zero? }
end

File.open(File.join(__dir__, "input.txt")) do |file|
  boxes = file.each.map { |line| Box.from_line(line) }.compact
  puts "Squares with multiple claims: #{squares_with_multiple_claims(boxes)}"
  puts "Box without overlap: #{box_without_overlap(boxes).id}"
end
