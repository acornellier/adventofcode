lines = File.readlines('../input.txt')

grid = lines.map { |line| line.chars.to_a }

LEFT = '<'
RIGHT = '>'
DOWN = 'v'
UP = '^'
DIRECTIONS = [LEFT, UP, RIGHT, DOWN]

HORIZONTAL = '-'
VERTICAL = '|'
BACK = '\\'
FORWARD = '/'
INTERSECTION = '+'

TURNS = {
  LEFT => {
    BACK => UP,
    FORWARD => DOWN
  },
  RIGHT => {
    BACK => DOWN,
    FORWARD => UP
  },
  DOWN => {
    BACK => RIGHT,
    FORWARD => LEFT
  },
  UP => {
    BACK => LEFT,
    FORWARD => RIGHT
  }
}

LEFT_TURN = -1
STRAIGHT_TURN = 0
RIGHT_TURN = 1
PRIORITY = [LEFT_TURN, STRAIGHT_TURN, RIGHT_TURN]

class Cart
  attr_accessor :y, :x, :dir, :step, :alive
  def initialize(y, x, dir, step)
    @y = y
    @x = x
    @dir = dir
    @step = step
    @alive = true
  end
end

carts =
  grid.flat_map.with_index do |line, y|
    line
      .map
      .with_index do |char, x|
        next unless DIRECTIONS.include? char
        grid[y][x] = HORIZONTAL if char == LEFT || char == RIGHT
        grid[y][x] = VERTICAL if char == UP || char == DOWN
        Cart.new(y, x, char, 0)
      end
      .compact
  end

loop do
  carts
    .sort_by! { |a| [a.y, a.x] }
    .each do |cart|
      next if cart.nil?

      y, x, = cart.y, cart.x
      case cart.dir
      when LEFT
        x -= 1
      when RIGHT
        x += 1
      when UP
        y -= 1
      when DOWN
        y += 1
      end

      cart.dir =
        case grid[y][x]
        when INTERSECTION
          turn = PRIORITY[cart.step % 3]
          cart.step += 1
          DIRECTIONS[(DIRECTIONS.index(cart.dir) + turn) % DIRECTIONS.size]
        when BACK, FORWARD
          TURNS[cart.dir][grid[y][x]]
        else
          cart.dir
        end

      cart.y = y
      cart.x = x

      carts.each do |other|
        next unless cart != other && cart.y == other.y && cart.x == other.x
        puts "crash x,y = #{cart.x},#{cart.y}"
        cart.alive = false
        other.alive = false
      end
    end

  carts.select!(&:alive)
  break if carts.size == 1
end

puts "final cart x,y = #{carts.first.x},#{carts.first.y}"
