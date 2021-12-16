require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

map =
  (0...5).flat_map do |y|
    lines.map do |line|
      (0...5).flat_map { |x| line.chars.map { (_1.to_i + y + x - 1) % 9 + 1 } }
    end
  end

g = Grid.new(map, 0, 0)

goal = [g.g.size - 1, g[0].size - 1]

dijkstra(
  [0, 0],
  ->(state) { state == goal },
  ->(state) do
    g.teleport(*state)
    g.bounded_neighbor_coords
  end,
  ->(state, neighbor) { g.at(*neighbor) },
  ->(neighbor) { (goal[0] - neighbor[0]) + (goal[1] - neighbor[1]) },
)
