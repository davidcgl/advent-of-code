def move(stars, velos, tick)
  stars.map.with_index do |(x, y), i|
    new_x = x + tick * velos[i][0]
    new_y = y + tick * velos[i][1]
    [new_x, new_y]
  end
end

def edges(stars)
  min_x, max_x = stars.map { |s| s[0] }.minmax
  min_y, max_y = stars.map { |s| s[1] }.minmax
  [min_x, max_x, min_y, max_y]
end

def plot(stars)
  min_x, max_x, min_y, max_y = edges(stars)
  grid =
    (min_y..max_y).map do |y|
      (min_x..max_x).map do |x|
        stars.include?([x, y]) ? '#' : '.'
      end
    end
  puts grid.map { |row| row.join(' ') }.join("\n")
end

File.open(File.join(__dir__, 'input.txt')) do |file|
  stars = []
  velos = []
  file.each do |line|
    stars << /position=< *(\S+), *(\S+)>/.match(line).captures.map(&:to_i)
    velos << /velocity=< *(\S+), *(\S+)>/.match(line).captures.map(&:to_i)
  end

  min_tick = 0
  min_area = Float::INFINITY

  # Find out position of stars that result in the minimum bounding box.
  20_000.times do |tick|
    min_x, max_x, min_y, max_y = edges(move(stars, velos, tick))
    area = (max_x - min_x + 1) * (max_y - min_y + 1)
    if area < min_area
      puts "#{tick}: #{area}"
      min_tick = tick
      min_area = area
    end
  end

  plot(move(stars, velos, min_tick))
  puts "Message appeared after #{min_tick} seconds"
end
