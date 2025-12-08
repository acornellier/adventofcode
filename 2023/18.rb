require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)

dir_map = { '0' => RIGHT, '1' => DOWN, '2' => LEFT, '3' => UP }

cur = [0, 0]
filled = [cur]
perimeter = 0
lines.each do |line|
  dist = line.split.last[2, 5].hex
  dir = dir_map[line[-2]]
  cur = move_from(*cur, dir, dist)
  filled << cur
  perimeter += dist
end

filled.pop

area = 0
filled.each_cons(2) do |(y1, x1), (y2, x2)|
  area += x1 * y2 - x2 * y1
end
area /= 2

interior = area - perimeter / 2 + 1

p perimeter + interior
