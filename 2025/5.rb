require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

groups = str_groups_separated_by_blank_lines(__FILE__)
ranges = groups[0].map do |line|
  a, b = line.split('-').map(&:to_i)
  a..b
end

finals = []
ranges.sort_by(&:begin).each do |range|
  if finals.empty? || range.begin > finals[-1].end + 1
    finals << range
  else
    prev = finals.pop
    finals << (prev.begin..[prev.end, range.end].max)
  end
end

p finals.sum(&:size)
