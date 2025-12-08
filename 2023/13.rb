require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<Array<String>>]
groups = str_groups_separated_by_blank_lines(__FILE__)
groups.map! { _1.map(&:chars) }

def diff_pattern(pattern)
  line = nil
  alt = nil
  (0..pattern.size - 2).each do |y|
    sub_height = [y + 1, pattern.size - y - 1].min
    top = pattern[y + 1 - sub_height, sub_height]
    bottom = pattern[y + 1, sub_height].reverse
    diff = top.flatten.zip(bottom.flatten).count { _1 != _2 }
    line = y if diff == 0
    alt = y if diff == 1
  end
  [line, alt]
end

vals = groups.map do |pattern|
  horiz, alt_horiz = diff_pattern(pattern)
  vert, alt_vert = diff_pattern(pattern.transpose)
  [horiz ? 100 * (horiz + 1) : vert + 1, alt_horiz ? 100 * (alt_horiz + 1) : alt_vert + 1]
end

part1 = vals.sum { _1[0] }
part2 = vals.sum { _1[1] }

p part1
p part2
