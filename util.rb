require 'set'

def lines
  @lines ||= $<.read.split("\n")
end

def first_line
  lines[0]
end

UP = 0
RIGHT = 1
DOWN = 2
LEFT = 3
REVERSE = ->(dir) { (dir + 2) % 4 }
DIRECTIONS = [UP, RIGHT, DOWN, LEFT]

class Grid
  attr_accessor :g, :y, :x, :dir

  def initialize(grid, y = nil, x = nil, dir = nil)
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
  
  def coords
    [@y, @x]
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
  
  def temp_move(dir = @dir)
    move(dir)
    yield.tap do
      reverse(dir)
    end
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
    end
  end

  def map_neighbors
    DIRECTIONS.map do |dir|
      temp_move(dir) { yield }
    end.compact
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
end

def dijkstra(initial_state, exit_condition, neighbors, distance = ->(_, d) { d + 1 })
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

    neighbors.call(cur).each do |neighbor|
      next if visited.include?(neighbor)
      states[neighbor] = [states[neighbor] || Float::INFINITY, distance.call(neighbor, shortest_distance)].min
    end
  end
end

def intcode(code, infun, outfun)
  code = code.dup + [0] * 1000
  ps = 0
  done = false
  relative_base = 0

  until done
    modea = (code[ps] % 100000) / 10000
    modeb = (code[ps] % 10000) / 1000
    modec = (code[ps] % 1000) / 100

    addr1 = modec == 2 ? code[ps + 1] + relative_base : code[ps + 1]
    val1 = modec == 1 ? addr1 : code[addr1]
    addr2 = modeb == 2 ? code[ps + 2] + relative_base : code[ps + 2]
    val2 = modeb == 1 ? addr2 : code[addr2]
    addr3 = modea == 2 ? code[ps + 3] + relative_base : code[ps + 3]

    case code[ps] % 100
    when 1
      code[addr3] = val1 + val2
      ps += 4
    when 2
      code[addr3] = val1 * val2
      ps += 4
    when 3
      code[addr1] = infun[]
      ps += 2
    when 4
      outfun[val1]
      ps += 2
    when 5
      (val1 != 0) ? (ps = val2) : ps += 3
    when 6
      (val1 == 0) ? (ps = val2) : ps += 3
    when 7
      code[addr3] = val1 < val2 ? 1 : 0
      ps += 4
    when 8
      code[addr3] = val1 == val2 ? 1 : 0
      ps += 4
    when 9
      relative_base += val1
      ps += 2
    when 99
      done = true
    else
      raise '??'
    end
  end
end