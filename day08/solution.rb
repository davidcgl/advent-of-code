def sum_metadata(tokens)
  return if tokens.empty?

  num_children = tokens.shift
  num_metadata = tokens.shift
  children_sum = Array.new(num_children) { sum_metadata(tokens) }.sum
  children_sum + tokens.shift(num_metadata).sum
end

def node_value(tokens)
  return 0 if tokens.empty?

  num_children = tokens.shift
  num_metadata = tokens.shift
  return tokens.shift(num_metadata).sum if num_children.zero?

  child_values = Array.new(num_children) { node_value(tokens) }
  tokens.shift(num_metadata).sum { |i| child_values[i - 1] || 0 }
end

File.open(File.join(__dir__, 'input.txt')) do |file|
  tokens = file.readline.split.map(&:to_i)
  puts "Sum of all metadata entires: #{sum_metadata(tokens.dup)}"
  puts "Root value: #{node_value(tokens.dup)}"
end
