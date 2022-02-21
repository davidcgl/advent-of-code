# frozen_string_literal: true

require "set"

def first_duplicate_frequency(changes)
  frequency = 0
  seen = Set.new
  changes.cycle do |change|
    frequency += change
    return frequency if seen.add?(frequency).nil?
  end
end

File.open(File.join(__dir__, "input.txt")) do |file|
  changes = file.each.map(&:to_i)
  puts "Resulting frequency: #{changes.sum}"
  puts "First duplicate frequency: #{first_duplicate_frequency(changes)}"
end
