# frozen_string_literal: true

def distance(a, b)
  (a[:x] - b[:x]).abs + (a[:y] - b[:y]).abs
end

def each_cell(bounding_box)
  min_x, max_x, min_y, max_y = *bounding_box
  Enumerator.new do |enum|
    (min_x..max_x).map do |x|
      (min_y..max_y).map do |y|
        enum << { x:, y: }
      end
    end
  end
end

def edge?(cell, bounding_box)
  min_x, max_x, min_y, max_y = *bounding_box
  [min_x, max_x].include?(cell[:x]) || [min_y, max_y].include?(cell[:y])
end

File.open(File.join(__dir__, "input.txt")) do |file|
  anchors = file.each.map do |line|
    x, y = /(\d+), (\d+)/.match(line).captures.map(&:to_i)
    { x:, y: }
  end

  bounding_box = [
    anchors.min_by { |a| a[:x] }[:x],
    anchors.max_by { |a| a[:x] }[:x],
    anchors.min_by { |a| a[:y] }[:y],
    anchors.max_by { |a| a[:y] }[:y],
  ]

  closest = each_cell(bounding_box).group_by do |cell|
    candidates = anchors.group_by { |a| distance(a, cell) }.min[1]
    # If >1 anchors have the same distance to cell, it should not be counted.
    candidates.size == 1 ? candidates.first : nil
  end

  # What is the size of the largest area that isn't infinite?
  max_area =
    closest
      .values
      .reject { |cells| cells.any? { |cell| edge?(cell, bounding_box) } }
      .map(&:size)
      .max
  puts "Largest area (not infinite): #{max_area}"

  # What is the size of the region containing all locations which have a total
  # distance to all given coordinates of less than 10000?
  safe_area = each_cell(bounding_box).count do |cell|
    anchors.sum { |a| distance(a, cell) } < 10_000
  end
  puts "Safe area: #{safe_area}"
end
