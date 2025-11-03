require_relative 'util'
require_relative 'input'

@example_extension = 'ex5'

lines = get_input_str_arr(__FILE__)

tile_dirs = {
  '|' => [UP, DOWN],
  '-' => [LEFT, RIGHT],
  'L' => [UP, RIGHT],
  'J' => [UP, LEFT],
  'F' => [DOWN, RIGHT],
  '7' => [DOWN, LEFT],
  'S' => DIRECTIONS,
  '.' => DIRECTIONS,
}

start_y = lines.index { _1.include?('S') }
start_x = lines[start_y].index('S')
g = Grid.new(lines, start_y, start_x)

first_dir = DIRECTIONS.find do |dir|
  g.temp_move(dir) do
    !g.out_of_bounds? && tile_dirs[g.cur].any? do |dir2|
      g.neighbor(dir2) === 'S'
    end
  end
end

path = [g.coords]
prev = first_dir
g.move(first_dir)
path << g.coords

loop do
  dir = tile_dirs[g.cur].find do
    (prev.nil? || REVERSE.call(_1) != prev) && g.neighbor(_1) != '.'
  end
  prev = dir
  g.move(dir)
  break if g.cur == 'S'
  path << g.coords
end

height = g.g.size
width = g[0].size
is_on_edge = ->(y, x) { y == 0 || y == height - 1 || x == 0 || x == width - 1 }

path_set = path.to_set
outside_set = (0...height).flat_map do |y0|
  (0...width).filter_map do |x0|
    [y0, x0] if is_on_edge[y0, x0] && !path_set.include?([y0, x0])
  end
end.to_set

visited = outside_set.dup
stack = outside_set.to_a
until stack.empty?
  y, x = stack.pop
  p "Visiting #{y}, #{x }"
  g.teleport(y, x)
  visited << [y, x]
  outside_set << [y, x] unless path_set.include?([y, x])
  good_neighbors = tile_dirs[g.cur].filter_map do |dir|
    g.temp_move(dir) do
      next nil if g.out_of_bounds? || visited.include?(g.coords)
      next g.coords unless path_set.include?(g.coords)
      tile_dirs[g.cur].include?(dir) || tile_dirs[g.cur].include?(REVERSE.call(dir)) ? g.coords : nil
    end
  end
  p "Adding neighbors: #{good_neighbors}"
  stack.push(*good_neighbors)
end

inside_count = height * width - outside_set.size - path.size
puts
p "total size: #{height * width}, outside: #{outside_set.size}, path: #{path.size}, inside: #{inside_count}"
p inside_count

p 'i give up :('