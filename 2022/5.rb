require_relative 'util'
require_relative 'input'

a, b = str_groups_separated_by_blank_lines(__FILE__)

stack_count = a.last.split.map(&:to_i).max
stacks = (0...stack_count).map do |stack_idx|
  a.reverse[1..].filter_map do |line|
    char = line[1 + stack_idx * 4]
    char unless char == ' '
  end
end

stacks = a.map(&:chars)[..-2].transpose

b.each do
  a, b, c = _1.scan(/\d+/).map(&:to_i)

  stacks[c - 1] += stacks[b - 1][-a..-1]
  a.times do
    stacks[b - 1].delete_at(stacks[b - 1].size - 1)
  end
end

p stacks.map(&:last).join
