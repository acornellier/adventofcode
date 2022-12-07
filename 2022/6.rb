require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)
# nums = get_single_line_input_int_arr(__FILE__)
# nums = get_multi_line_input_int_arr(__FILE__)

s = lines[0]

s.chars.each.with_index do |c, idx|
  next unless idx >= 14
  p s[idx - 13..idx]
  if s[idx - 13..idx].chars.uniq.length == 14
    p (idx + 1)
    exit
  end
end

p 'none'

