require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# lines = get_input_str_arr(__FILE__)
groups = str_groups_separated_by_blank_lines(__FILE__)
# nums = get_single_line_input_int_arr(__FILE__)
# nums = get_multi_line_input_int_arr(__FILE__)

monkeys = groups.map do |group|
  items = group[1].split(': ')[1].split(', ').map(&:to_i)
  op = group[2].split(' = ')[1]
  if op.include?('*')
    n = op.split(' * ')[1]
    op = ->(x) { x * (n == 'old' ? x : n.to_i) }

  else
    n = op.split(' + ')[1].to_i
    op = ->(x) { x + (n == 'old' ? x : n.to_i) }
  end
  divisible_by = group[3].split(' by ')[1].to_i
  if_true = group[4].split('monkey ')[1].to_i
  if_false = group[5].split('monkey ')[1].to_i

  [items, op, divisible_by, if_true, if_false]
end

inspections = monkeys.map { 0 }
mod = monkeys.map { _1[2] }.inject(:*)
10000.times do
  monkeys.each.with_index do |monkey, idx|
    items, op, divisible_by, if_true, if_false = monkey

    items.each do |item_worry|
      inspections[idx] += 1
      item_worry = op.call(item_worry)
      # item_worry /= 3
      item_worry %= mod

      if item_worry % divisible_by == 0
        monkeys[if_true][0] << item_worry
      else
        monkeys[if_false][0] << item_worry
      end
    end

    monkey[0] = []
  end
end

p inspections.max(2).inject(:*)


