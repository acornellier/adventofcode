require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

t = Hash.new(0)
t[lines[0].index('S')] = 1

(0...lines.size).each do |y|
  (0...lines[0].size).each do |x|
    next unless lines[y][x] == '^'
    t[x - 1] += t[x]
    t[x + 1] += t[x]
    t[x] = 0
  end
end

p t.values.sum
