require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
cups = get_single_line_input_int_arr(__FILE__, separator: '')
max_label = cups.max
cups += (max_label + 1..10_000_000).to_a

cur = cups[0]
100.times do
  # p cups
  pick_up = cups.slice!(cups.index(cur) + 1, 3)
  pick_up += cups.slice!(0, 3 - pick_up.size) if pick_up.size < 3
  dest = cur - 1
  dest = (dest - 1) % (max_label + 1) until cups.include?(dest)

  # p [cur, pick_up, dest]

  cups.insert(cups.index(dest) + 1, pick_up).flatten!
  cur = cups[(cups.index(cur) + 1) % cups.size]
end

one_idx = cups.index(1)
# puts (cups[one_idx + 1..-1] + cups[0...one_idx]).join

puts [cups[one_idx + 1], cups[one_idx + 2]]
