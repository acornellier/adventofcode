require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

OFF = ' '
ON = '█'

g = Array.new(6) { Array.new(50, OFF) }
# g = Array.new(3) { Array.new(7, OFF) } # ejemplo
grid = Grid.new(g, nil, nil, nil)

lines.each do |line|
  p line
  words = line.split
  case words[0]
  when 'rect'
    w, h = words[1].split('x').map(&:to_i)
    (0...h). each do |y|
      (0...w).each do |x|
        g[y][x] = ON
      end
    end
  when 'rotate'
    coord = words[2].split('=').last.to_i
    val = words[4].to_i
    case words[1]
    when 'row'
      g[coord].rotate!(-val)
    when 'column'
      g = g.transpose
      g[coord].rotate!(-val)
      grid.g = g = g.transpose
    else
      raise words[1]
    end
  else
    raise words[0]
  end
  grid.draw
end

puts(g.sum { |row| row.count(ON) })
