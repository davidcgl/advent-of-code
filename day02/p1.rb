File.open(File.join(__dir__, 'input.txt')) do |file|
  twos = threes = 0
  file.each do |line|
    line.chars.group_by(&:itself).values.map(&:size).uniq.each do |size|
      twos += 1 if size == 2
      threes += 1 if size == 3
    end
  end
  puts twos * threes
end
