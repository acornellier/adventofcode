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

  def at(y, x)
    @g[y][x]
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
    DIRECTIONS.filter_map { |dir| temp_move(dir) { yield } }
  end

  def bounded_neighbors
    map_neighbors { out_of_bounds? ? nil : coords }
  end

  def bounded_neighbor_coords
    map_neighbors { out_of_bounds? ? nil : coords }
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

def reconstruct_path(came_from, state)
  path = [state]
  path.unshift(came_from[path[0]]) while came_from.include?(path[0])
  path
end

def dijkstra(
  initial_state,
  exit_condition, # -> (state) { false }
  neighbors, # -> (state) { [] }
  distance = ->(state, neighbor) { 1 },
  estimate_remaining = ->(neighbor) { 0 }
)
  came_from = {}

  scores_actual = Hash.new(Float::INFINITY)
  scores_actual[initial_state] = 0

  scores_estimate = Hash.new(Float::INFINITY)
  scores_estimate[initial_state] = 0

  until scores_estimate.empty?
    shortest_distance = scores_estimate.values.min
    cur = scores_estimate.key(shortest_distance)

    if exit_condition.call(cur)
      # path = reconstruct_path(came_from, cur)
      # p path
      puts shortest_distance
      return
    end

    scores_estimate.delete(cur)

    neighbors
      .call(cur)
      .each do |neighbor|
        score = scores_actual[cur] + distance.call(cur, neighbor)
        next unless score < (scores_actual[neighbor] || Float::INFINITY)

        came_from[neighbor] = cur
        scores_actual[neighbor] = score
        scores_estimate[neighbor] = score + estimate_remaining.call(neighbor)
      end
  end

  raise 'no possible moves'
end
