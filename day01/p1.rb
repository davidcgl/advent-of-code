File.open(File.join(__dir__, 'input.txt')) do |file|
  puts file.each.map(&:to_i).sum
end
