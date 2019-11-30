require 'set'

DOWN = 0
LEFT = 1
UP = 2
RIGHT = 3
REVERSE = ->(dir) { (dir + 2) % 4 }

class Grid
  attr_accessor :g, :y, :x, :dir

  def initialize(grid, y, x, dir)
    @g = grid
    @y = y
    @x = x
    @dir = dir
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
  
  def teleport(y, x)
    @y = y
    @x = x
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
    end
  end

  def turn_left
    @dir = (dir - 1) % 4
  end

  def turn_right
    @dir = (dir + 1) % 4
  end

  def turn_around
    @dir = (dir + 2) % 4
  end

  def neighbor(dir = @dir)
    case dir
    when UP
      @g[y - 1][x]
    when RIGHT
      @g[y][x + 1]
    when DOWN
      @g[y + 1][x]
    when LEFT
      @g[y][x - 1]
    end
  end
  
  def out_of_bounds?
    y < 0 || y >= @g.size || x < 0 || x >= @g[0].size
  end

  def draw
    @g.each.with_index do |r, i|
      s = r.dup
      s[x] = '@' if i == y
      puts s.is_a?(Array) ? s.join : s
    end
    puts
  end
end

def dijkstra(initial_state, exit_condition, distance, neighbors)
  states = Hash.new(Float::INFINITY)
  states[initial_state] = distance.call(initial_state)
  visited = Set.new

  loop do
    raise 'no possible moves' if states.empty?

    shortest_distance = states.values.min
    cur = states.key(shortest_distance)
    states.delete(cur)
    visited.add(cur)

    if exit_condition.call(cur)
      cur.draw
      puts visited.size, shortest_distance
      return
    end

    neighbors.call(cur).each do |neighbor|
      next if visited.include?(neighbor)
      states[neighbor] = [states[neighbor] || Float::INFINITY, distance.call(neighbor)].min
    end
  end
end