require 'set'

UP = 0
RIGHT = 1
DOWN = 2
LEFT = 3

UP_RIGHT = 4
UP_LEFT = 5
DOWN_LEFT = 6
DOWN_RIGHT = 7

REVERSE = ->(dir) { (dir + 2) % 4 + (dir >= 4 ? 4 : 0) }
DIRECTIONS = [UP, RIGHT, DOWN, LEFT]
ALL_DIRECTIONS = DIRECTIONS + [UP_RIGHT, UP_LEFT, DOWN_LEFT, DOWN_RIGHT]

class Grid
  attr_accessor :g, :y, :x, :dir

  def initialize(g, y = nil, x = nil, dir = nil)
    @g = g
    @y = y
    @x = x
    @dir = dir
  end

  def dup
    Grid.new(@g.map(&:dup), @y, @x, @dir)
  end

  def [](y)
    @g[y]
  end

  def cur
    @g[y][x]
  end

  def cur=(val)
    @g[y][x] = val
  end

  def coords
    [@y, @x]
  end

  def teleport(y, x)
    @y = y
    @x = x
  end

  def temp_move(dir = @dir)
    move(dir)
    yield.tap { reverse(dir) }
  end

  def reverse(dir = @dir)
    move(REVERSE[dir])
  end

  def turn_left
    @dir = (@dir - 1) % 4
  end

  def turn_right
    @dir = (@dir + 1) % 4
  end

  def turn_around
    @dir = (@dir + 2) % 4
  end

  def map_neighbors
    DIRECTIONS.map { |dir| temp_move(dir) { yield } }.compact
  end

  def out_of_bounds?
    @y < 0 || @y >= @g.size || @x < 0 || @x >= @g[0].size
  end

  def draw
    @g.each.with_index do |r, i|
      s = r.dup
      s[@x] = '@' if i == @y
      puts s.is_a?(Array) ? s.join : s
    end
    puts
  end

  def neighbor(dir = @dir)
    case dir
    when UP
      @g[@y - 1][@x]
    when RIGHT
      @g[@y][@x + 1]
    when DOWN
      @g[@y + 1][@x]
    when LEFT
      @g[@y][@x - 1]
    when UP_RIGHT
      @g[@y - 1][@x + 1]
    when UP_LEFT
      @g[@y - 1][@x - 1]
    when DOWN_LEFT
      @g[@y + 1][@x - 1]
    when DOWN_RIGHT
      @g[@y + 1][@x + 1]
    end
  end

  def move(dir = @dir)
    case dir
    when UP
      @y -= 1
    when RIGHT
      @x += 1
    when DOWN
      @y += 1
    when LEFT
      @x -= 1
    when UP_RIGHT
      @y -= 1
      @x += 1
    when UP_LEFT
      @y -= 1
      @x -= 1
    when DOWN_LEFT
      @y += 1
      @x -= 1
    when DOWN_RIGHT
      @y += 1
      @x += 1
    end
  end
end

def dijkstra(
  initial_state,
  exit_condition,
  neighbors,
  distance = ->(_, d) { d + 1 }
)
  states = Hash.new(Float::INFINITY)
  states[initial_state] = distance.call(initial_state, -1)
  visited = Set.new

  loop do
    raise 'no possible moves' if states.empty?

    shortest_distance = states.values.min
    cur = states.key(shortest_distance)
    states.delete(cur)
    visited.add(cur)

    if exit_condition.call(cur)
      puts shortest_distance
      return
    end

    neighbors
      .call(cur)
      .each do |neighbor|
        next if visited.include?(neighbor)
        states[neighbor] = [
          states[neighbor] || Float::INFINITY,
          distance.call(neighbor, shortest_distance),
        ].min
      end
  end
end
