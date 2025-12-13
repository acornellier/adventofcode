require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

groups = str_groups_separated_by_blank_lines(__FILE__)

res = groups[-1].count do |line|
  size, quantities = line.split(': ')
  width, height = size.split('x').map(&:to_i)
  quantities = quantities.split.map(&:to_i)
  area = width * height
  quantities.sum * 9 <= area
end

p res
