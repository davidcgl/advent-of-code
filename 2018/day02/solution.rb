# frozen_string_literal: true

def checksum(boxes)
  two_same_letters = 0
  three_same_letters = 0
  boxes.each do |box_id|
    box_id.chars.group_by(&:itself).values.map(&:size).uniq.each do |size|
      two_same_letters += 1 if size == 2
      three_same_letters += 1 if size == 3
    end
  end
  two_same_letters * three_same_letters
end

def find_pair_with_one_letter_difference(boxes)
  boxes.each do |box|
    candidate = box.dup
    candidate.chars.each_with_index do |char, i|
      ("a".."z").reject { |c| c == char }.each do |c|
        candidate[i] = c
        return [box, candidate, i] if boxes.include?(candidate)
      end
      candidate[i] = char
    end
  end
end

File.open(File.join(__dir__, "input.txt")) do |file|
  boxes = Set.new(file.each.map(&:strip).to_a)
  puts "Checksum: #{checksum(boxes)}"

  box1, box2, pos = find_pair_with_one_letter_difference(boxes)
  puts "Box IDs with one letter difference:"
  puts box1
  puts box2
  puts ("-" * pos) + "^"
end
