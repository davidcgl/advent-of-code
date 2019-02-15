require 'set'

File.open(File.join(__dir__, 'input.txt')) do |file|
  freq = 0
  seen = Set.new
  file.each.map(&:to_i).cycle do |num|
    freq += num
    break if seen.add?(freq).nil?
  end
  puts freq
end
