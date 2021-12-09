require_relative 'util'
require_relative 'input'

@example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

g = Grid.new(lines.map { _1.chars.map(&:to_i) })

basins = []
(0...g.g.size).each do |y|
  (0...g.g[0].size).each do |x|
    g.teleport(y, x)
    height = g.cur

    low_point = g.map_neighbors { !g.out_of_bounds? && g.cur <= height }.none?
    next unless low_point

    visited = []
    find_basin_size =
      lambda do |g, height|
        visited << g.coords
        1 +
          g.map_neighbors do
            next if g.out_of_bounds? || g.cur == 9
            next if visited.include?(g.coords)

            find_basin_size.call(g.dup, g.cur)
          end.sum
      end

    basins << find_basin_size.call(g, height)
  end
end

p basins.sort.last(3).inject(:*)
