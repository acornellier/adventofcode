require 'set'
require 'pqueue'

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

def move_from(y, x, dir, dist = 1)
  case dir
  when UP
    [y - dist, x]
  when RIGHT
    [y, x + dist]
  when DOWN
    [y + dist, x]
  when LEFT
    [y, x - dist]
  when UP_RIGHT
    [y - dist, x + dist]
  when UP_LEFT
    [y - dist, x - dist]
  when DOWN_LEFT
    [y + dist, x - dist]
  when DOWN_RIGHT
    [y + dist, x + dist]
  else
    raise "invalid dir: #{dir}"
  end
end

def left_dir(dir)
  (dir - 1) % 4
end

def right_dir(dir)
  (dir + 1) % 4
end

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

  def height
    @g.size
  end

  def width
    @g[0].size
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

  def temp_tp(y, x)
    prev_y, prev_x = @y, @x
    teleport(y, x)
    yield.tap { teleport(prev_y, prev_x) }
  end

  def temp_move(dir = @dir)
    move(dir)
    yield.tap { reverse(dir) }
  end

  def reverse(dir = @dir)
    move(REVERSE[dir])
  end

  def turn_left
    @dir = left_dir(@dir)
  end

  def turn_right
    @dir = right_dir(@dir)
  end

  def turn_around
    @dir = (@dir + 2) % 4
  end

  def neighbors(y = @y, x = @x, all = false)
    (all ? ALL_DIRECTIONS : DIRECTIONS).filter_map do |dir|
      y2, x2 = move_from(y, x, dir)
      out_of_bounds?(y2, x2) ? nil : at(y2, x2)
    end
  end

  def out_of_bounds?(y = @y, x = @x)
    y < 0 || y >= @g.size || x < 0 || x >= @g[0].size
  end

  def draw
    @g.each.with_index do |r, i|
      s = r.dup
      s[@x] = '@' if i == @y
      puts s.is_a?(Array) ? s.join : s
    end
    puts
  end

  def dir_coords(dir = @dir)
    move_from(@y, @x, dir)
  end

  def neighbor(dir = @dir)
    y, x = dir_coords(dir)
    @g[y][x]
  end

  def move(dir = @dir)
    @y, @x = move_from(@y, @x, dir)
  end

  def each_coord
    return enum_for(__method__) unless block_given?
    (0...height).each { |y| (0...width).each { |x| yield y, x } }
  end
end

def print_reconstructed_path(came_from, state, score)
  p "solved!"
  puts score
  path = [state]
  path.unshift(came_from[path[0]]) while came_from.include?(path[0])
  p path
end

def dijkstra(
  initial_state,
  exit_condition, # ->(state) { false }
  neighbors, # ->(state) { [neighbor] }
  estimate_remaining: ->(neighbor) { 0 }
)
  came_from = {}

  scores_actual = Hash.new(Float::INFINITY)
  scores_actual[initial_state] = 0

  scores_estimate = Hash.new(Float::INFINITY)
  scores_estimate[initial_state] = 0

  pq = PQueue.new { scores_estimate[_1] < scores_estimate[_2] }
  pq.push(initial_state)

  until scores_estimate.empty?
    cur = pq.pop

    if exit_condition.call(cur)
      # print_reconstructed_path(came_from, cur, scores_estimate[cur])
      return scores_estimate[cur]
    end

    scores_estimate.delete(cur)

    new_neighbors = neighbors.call(cur)
    new_neighbors.each do |neighbor, dist|
      score = scores_actual[cur] + dist || 1
      next unless score < scores_actual[neighbor]

      came_from[neighbor] = cur
      scores_actual[neighbor] = score
      scores_estimate[neighbor] = score + estimate_remaining.call(neighbor)
      pq.push(neighbor)
    end
  end

  raise 'no possible moves'
end
