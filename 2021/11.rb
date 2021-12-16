require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)
# nums = get_single_line_input_int_arr(__FILE__)
# nums = get_multi_line_input_int_arr(__FILE__)

flashes = 0

g = Grid.new(lines.map { |l| l.chars.map(&:to_i) } )

(1..10_000).each do |n|
  (0...lines.size).each do |y|
    (0...lines.size).each do |x|
      g[y][x] += 1
    end
  end

  flashed = []
  (0...lines.size).each do |y|
    (0...lines.size).each do |x|

      flash = ->(y2, x2) do
        next if g[y2][x2] <= 9 || flashed.include?([y2, x2])
        
        flashes += 1
        flashed << [y2, x2]
        ALL_DIRECTIONS.map do |dir|
          g.teleport(y2, x2)
          g.move(dir)
          next if g.out_of_bounds?
          g.cur += 1
          flash.call(g.y, g.x)
        end
      end

      flash.call(y, x)
    end
  end

  
  if flashed.size == lines.size ** 2
    p 'done!'
    p flashed.size
    g.draw
    p n
    break
  end

  (0...lines.size).each do |y|
    (0...lines.size).each do |x|
      g[y][x] = 0 if g[y][x] > 9
    end
  end
end
