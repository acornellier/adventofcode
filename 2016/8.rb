require_relative 'util'
lines = $stdin.read.strip.split("\n")

OFF = ' '
ON = '█'

ship = Array.new(6) { Array.new(50, OFF) }
# g = Array.new(3) { Array.new(7, OFF) } # ejemplo
grid = Util.new(ship, nil, nil, nil)

lines.each do |line|
  p line
  words = line.split
  case words[0]
  when 'rect'
    w, h = words[1].split('x').map(&:to_i)
    (0...h).each { |y| (0...w).each { |x| ship[y][x] = ON } }
  when 'rotate'
    coord = words[2].split('=').last.to_i
    val = words[4].to_i
    case words[1]
    when 'row'
      ship[coord].rotate!(-val)
    when 'column'
      g = ship.transpose
      ship[coord].rotate!(-val)
      grid.g = g = ship.transpose
    else
      raise words[1]
    end
  else
    raise words[0]
  end
  grid.draw
end

puts(ship.sum { |row| row.count(ON) })
