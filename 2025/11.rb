require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

$nodes = lines.to_h do |l|
  from, *to = l.chomp.split(" ")
  [from[0..-2], to]
end

$memory = Hash.new
$to_visit = ["fft", "dac"].to_set
$nothing = Set.new

def count_paths(node)
  return { $nothing => 1 } if node == "out"
  return $memory[node] if $memory[node]

  child_counts = $nodes[node]
                   .map { |n| count_paths(n) }
                   .reduce do |s, e|
    s.merge(e) { |_, a, b| a + b }
  end

  if $to_visit.include? node
    child_counts = child_counts.to_h { |k, v| [k + [node], v] }
  end

  $memory[node] = child_counts
end

pp count_paths("you")
pp count_paths("svr")