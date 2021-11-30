require_relative 'util'
lines = $stdin.read.chomp.split("\n")

OPEN = '.'
WALL = '#'

SIZE = 50
ship = Util.new(Array.new(SIZE) { ' ' * SIZE }, 1, 1, nil)

(0...SIZE).each do |y|
  (0...SIZE).each do |x|
    ship[y][x] =
      if (x * x + 3 * x + 2 * x * y + y + y * y + lines[0].to_i)
           .to_s(2)
           .count('1')
           .even?
        OPEN
      else
        WALL
      end
  end
end

exit_condition = ->(state) do
  state[0] == lines[1].to_i && state[1] == lines[2].to_i
end

neighbors = ->(state) do
  [UP, LEFT, RIGHT, DOWN].map do |dir|
    ship.teleport(*state)
    ship.move(dir)
    ship.out_of_bounds? || ship.cur == WALL ? nil : [ship.y, ship.x]
  end.compact
end

dijkstra([1, 1], exit_condition, neighbors)
