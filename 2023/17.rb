require_relative 'util'
require_relative 'input'

@example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)

g = Grid.new(lines)

initial_state = [[0, 0], nil, 0]

exit_condition = ->(state) { state[0] == [lines.size - 1, lines.size - 1] }

neighbors = ->(state) do
  coords, dir, repeat = state
  dirs = dir ? [dir, left_dir(dir), right_dir(dir)] : [RIGHT, DOWN]

  return dirs.filter_map do |new_dir|
    straight = new_dir == dir
    next if straight && repeat >= 10
    next if dir && !straight && repeat < 4

    g.teleport(*coords)
    g.move(new_dir)
    next if g.out_of_bounds?

    [g.coords, new_dir, straight ? repeat + 1 : 1]
  end
end

distance = ->(_state, neighbor) do
  g.at(*neighbor[0]).to_i
end

res = dijkstra(initial_state, exit_condition, neighbors, distance)

p res
