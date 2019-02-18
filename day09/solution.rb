Node = Struct.new(:marble, :prev, :next)

def insert_after(node, marble)
  new_node = Node.new(marble, node, node.next)
  node.next.prev = new_node
  node.next = new_node
  new_node
end

def delete_node(node)
  node.next.prev = node.prev
  node.prev.next = node.next
end

def play(num_players, last_marble)
  scores = Array.new(num_players, 0)
  turn = num_players.times.cycle
  node = Node.new(0)
  node.next = node.prev = node

  (1..last_marble).each do |marble|
    player = turn.next
    if marble % 23 == 0
      7.times { node = node.prev }
      scores[player] += node.marble + marble
      node = node.next
      delete_node(node.prev)
    else
      node = insert_after(node.next, marble)
    end
  end

  scores.max
end

File.open(File.join(__dir__, 'input.txt')) do |file|
  input = file.readline
  num_players = /(\d+) players/.match(input)[1].to_i
  last_marble = /(\d+) points/.match(input)[1].to_i

  puts "winner: #{play(num_players, last_marble)}"
  puts "winner: #{play(num_players, last_marble * 100)}"
end