require_relative 'util'

# input = File.read('./ejemplo.txt')
input = File.read('input.txt')
lines = input.split("\n").map(&:chomp)

ship = Grid.new([[]], 0, 0, RIGHT)
waypoint = Grid.new([[]], -1, 10)

lines.each do |line|
  dir, mag = line[0], line[1..].to_i
  case dir
  when 'N'
    (mag).times { waypoint.move(UP) }
  when 'S'
    (mag).times { waypoint.move(DOWN) }
  when 'E'
    (mag).times { waypoint.move(RIGHT) }
  when 'W'
    (mag).times { waypoint.move(LEFT) }
  when 'L'
    case mag
    when 90
      waypoint.teleport(-waypoint.x, waypoint.y)
    when 180
      waypoint.teleport(-waypoint.y, -waypoint.x)
    when 270
      waypoint.teleport(waypoint.x, -waypoint.y)
    else
      throw
    end
  when 'R'
    case mag
    when 90
      waypoint.teleport(waypoint.x, -waypoint.y)
    when 180
      waypoint.teleport(-waypoint.y, -waypoint.x)
    when 270
      waypoint.teleport(-waypoint.x, waypoint.y)
    else
      throw
    end
  when 'F'
    (mag).times { ship.teleport(ship.y + waypoint.y, ship.x + waypoint.x) }
  end
  p line
  p ship.coords
  p waypoint.coords
  puts
end

p ship.coords
p ship.coords.map(&:abs).sum
