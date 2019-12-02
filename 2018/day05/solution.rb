def react?(a, b)
  (a != b) && (a == b.downcase || a == b.upcase)
end

def reduce(polymer, ignore = [])
  polymer
    .each_char
    .reject { |unit| ignore.include?(unit) }
    .each_with_object([]) do |unit, reduction|
      if react?(reduction.last, unit)
        reduction.pop
      else
        reduction << unit
      end
    end
end

File.open(File.join(__dir__, 'input.txt')) do |file|
  # Reading 50,000 chars is _fine_.
  polymer = file.readline

  # How many units remain after fully reacting the polymer you scanned?
  reduction_size = reduce(polymer).size
  puts "Remaining units: #{reduction_size}"

  # What is the length of the shortest polymer you can produce by removing all
  # units of exactly one type and fully reacting the result?
  unit, reduction_size =
    ('a'..'z')
    .map { |unit| [unit, reduce(polymer, [unit, unit.upcase]).size] }
    .min_by { |_unit, size| size }

  puts "Most problematic unit: #{unit.upcase}/#{unit}"
  puts "Remaining units with #{unit.upcase}/#{unit} removed: #{reduction_size}"
end
