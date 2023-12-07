def create_node(name:, type:, size:)
  {
    name: name,
    type: type,
    size: size,
    children: {}
  }
end

def ensure_child_exists(node, name:, type:, size: 0)
  node[:children][name] ||= create_node(name: name, type: type, size: size)
end

def update_sizes(node)
  if node[:type] == :file
    return node[:size]
  end

  node[:size] = node[:children].values.sum do |child_node|
    update_sizes(child_node)
  end

  node[:size]
end

def create_filetree(path)
  root = create_node(name: "/", type: :dir, size: 0)
  cwd = [root]
  op = nil

  File.open(path).each_line do |line|
    tokens = line.split.map(&:strip)
    cur_node = cwd.last

    case tokens[0]
    when "$"
      case tokens[1]
      when "cd"
        op = :cd
        name = tokens[2]

        case name
        when "/"
          cwd = [root]
        when ".."
          cwd.pop
        else
          ensure_child_exists(cur_node, name: name, type: :dir)
          cwd << cur_node[:children][name]
        end
      when "ls"
        op = :ls
      end
    when "dir"
      name = tokens[1]
      ensure_child_exists(cur_node, name: name, type: :dir)
    when /(\d+)/
      name = tokens[1]
      size = tokens[0].to_i
      ensure_child_exists(cur_node, name: name, type: :file, size: size)
    end
  end

  update_sizes(root)
  root
end

def walk(root)
  stack = [root]

  until stack.empty?
    node = stack.pop
    yield node
    if node[:type] == :dir
      stack.concat(node[:children].values)
    end
  end
end

def part_one(path)
  root = create_filetree(path)
  size_total = 0

  walk(root) do |node|
    if node[:type] == :dir && node[:size] < 100_000
      size_total += node[:size]
    end
  end

  size_total
end

def part_two(path)
  root = create_filetree(path)
  size_total = 70_000_000
  size_unused = size_total - root[:size]
  size_needed = 30_000_000 - size_unused
  size_min = size_total

  walk(root) do |node|
    if node[:type] == :dir && node[:size] >= size_needed && node[:size] < size_min
      size_min = node[:size]
    end
  end

  size_min
end

path = File.join(__dir__, ARGV[0] || "day07.input01.txt")
puts "part one: #{part_one(path)}"
puts "part two: #{part_two(path)}"
