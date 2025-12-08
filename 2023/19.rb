require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

groups = str_groups_separated_by_blank_lines(__FILE__)

workflows = groups[0].to_h do |line|
  match = line.match(/(\w+)\{(.*?)\}/)
  name = match[1]
  rules = match[2].split(',').map do |rule|
    next rule unless rule.include?(':')
    m = rule.match /([xmas])([<>])(\d+):(\w+)/
    [m[1], m[2], m[3].to_i, m[4]]
  end
  [name, rules]
end

def count_good(cur, rule_index, ranges, workflows)
  return ranges.values.map(&:size).inject(:*) if cur == 'A'
  return 0 if cur == 'R'

  cur_rule = workflows.dig(cur, rule_index)
  return count_good(cur_rule, 0, ranges, workflows) if cur_rule.is_a? String

  var, comp, val, new_workflow = cur_rule
  range = ranges[var]
  if comp == '<'
    r_true = (range.begin..(val - 1))
    r_false = (val..range.end)
  else
    r_true = ((val + 1)..range.end)
    r_false = (range.begin..val)
  end

  count_good(new_workflow, 0, ranges.merge(var => r_true), workflows) +
    count_good(cur, rule_index + 1, ranges.merge(var => r_false), workflows)
end

ranges = { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 1..4000 }
p count_good('in', 0, ranges, workflows)
