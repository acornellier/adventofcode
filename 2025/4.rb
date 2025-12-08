require_relative 'util'
require_relative 'input'

@example_extension = 'ex1'

g = Grid.new(get_input_str_arr(__FILE__))

total_removed = 0
loop do
  to_remove = g.each_coord.select do |y, x|
    g[y][x] == ?@ && g.neighbors(y, x, all: true).count(?@) < 4
  end

  break if to_remove.empty?

  to_remove.each { g[_1][_2] = '.' }
  total_removed += to_remove.size
end

p total_removed
