DOWN = 0
LEFT = 1
UP = 2
RIGHT = 3

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
      puts s
    end
    puts
  end
end