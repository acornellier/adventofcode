require_relative 'util'
require_relative 'input'

groups = str_groups_separated_by_blank_lines(__FILE__)

stack_count = groups[0].last.split.map(&:to_i).max
stacks = []
groups[0].reverse[1..].each do |line|
  (0...stack_count).each do |stack_idx|
    stacks[stack_idx] ||= []
    char = line[1 + stack_idx * 4].strip
    stacks[stack_idx] << char unless char.empty?
  end
end

groups[1].each do |instruction|
  match = instruction.match(/move (\d+) from (\d+) to (\d+)/)
  a, b, c = match[1..].map(&:to_i)

  stacks[c - 1] += stacks[b - 1][-a..-1]
  a.times do
    stacks[b - 1].delete_at(stacks[b - 1].size - 1)
  end
end

p stacks.map(&:last).join
