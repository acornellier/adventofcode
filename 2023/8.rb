require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)
# @type [Array<Array<String>>]
# groups = str_groups_separated_by_blank_lines(__FILE__)

sequence = lines[0].tr("LR", "01").chars.map(&:to_i)

network = lines[2..].to_h do |line|
  match = line.match(/(...) = \((...), (...)\)/)
  [match[1], [match[2], match[3]]]
end

cur_nodes = network.keys.select { _1.end_with?('A') }
visited = Array.new(cur_nodes.size) { [] }
loops = [nil] * cur_nodes.size

steps = 0
sequence.cycle.with_index do |step, seq_idx|
  seq_idx = seq_idx % sequence.size

  cur_nodes.each_with_index do |node, idx|
    next unless loops[idx].nil?
    visited_idx = visited[idx].find_index { _1 == node && _2 == seq_idx }
    if visited_idx
      loops[idx] = steps - visited_idx
    end
  end

  visited.map!.with_index do |path, idx|
    path << [cur_nodes[idx], seq_idx]
  end

  cur_nodes.map! do |cur_node|
    network[cur_node][step]
  end

  steps += 1

  break if loops.all?
end

p loops.reduce(:lcm)

