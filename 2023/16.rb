require_relative 'util'
require_relative 'input'

@example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

def count_energized(lines, y, x, dir)
  grids = [Grid.new(lines, y, x, dir)]
  energized = {}

  draw = ->() do
    g = Grid.new(lines.map(&:dup))
    energized.keys.each do |y, x|
      g.temp_tp(y, x) do
        g.cur = '#'
      end
    end
    g.draw
  end

  turns_without_changing = 0
  loop do
    prev_energized_count = energized.size
    new_grids = []

    grids.each do |g|
      (energized[g.coords] ||= []) << g.dir

      if g.cur == '/'
        if g.dir == UP || g.dir == DOWN
          g.turn_right
        elsif g.dir == RIGHT || g.dir == LEFT
          g.turn_left
        end
      elsif g.cur == '\\'
        if g.dir == UP || g.dir == DOWN
          g.turn_left
        elsif g.dir == RIGHT || g.dir == LEFT
          g.turn_right
        end
      elsif g.cur == '|'
        if g.dir == RIGHT || g.dir == LEFT
          g.dir = UP
          new_grids << Grid.new(lines, g.y, g.x, DOWN)
        end
      elsif g.cur == '-'
        if g.dir == UP || g.dir == DOWN
          g.dir = LEFT
          new_grids << Grid.new(lines, g.y, g.x, RIGHT)
        end
      end
    end

    grids.concat(new_grids)

    grids.each { _1.move }
    grids.delete_if(&:out_of_bounds?)
    grids.delete_if do |grid|
      energized[grid.coords]&.include?(grid.dir)
    end

    # draw[]

    if grids.size == 0 || prev_energized_count == energized.size
      turns_without_changing += 1
      break if turns_without_changing > 100
    else
      turns_without_changing = 0
    end
  end

  energized.size
end

max = 0
w = lines.size - 1
0.upto(w) do |y|
  max = [max, count_energized(lines, y, 0, RIGHT)].max
end
0.upto(w) do |y|
  max = [max, count_energized(lines, y, w, LEFT)].max
end
0.upto(w) do |x|
  max = [max, count_energized(lines, 0, x, DOWN)].max
end
0.upto(w) do |x|
  max = [max, count_energized(lines, w, x, UP)].max
end
p max
