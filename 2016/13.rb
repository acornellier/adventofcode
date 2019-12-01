require_relative 'util'
lines = $stdin.read.chomp.split("\n")

OPEN = '.'
WALL = '#'

SIZE = 50
g = Util.new(Array.new(SIZE) { ' ' * SIZE }, 1, 1, nil)

(0...SIZE).each do |y|
  (0...SIZE).each do |x|
    g[y][x] = (x*x + 3*x + 2*x*y + y + y*y + lines[0].to_i).to_s(2).count('1').even? ? OPEN : WALL
  end
end

exit_condition = ->(state) do
  state[0] == lines[1].to_i && state[1] == lines[2].to_i
end

neighbors = ->(state) do
  [UP, LEFT, RIGHT, DOWN].map do |dir|
    g.teleport(*state)
    g.move(dir)
    g.out_of_bounds? || g.cur == WALL ? nil : [g.y, g.x]
  end.compact
end

dijkstra([1, 1], exit_condition, neighbors)
