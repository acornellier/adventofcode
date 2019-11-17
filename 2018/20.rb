require 'set'

class String
  def rep(replace, start)
    self[start..(start + 2)] = replace
    self
  end
end

lines = $<.readlines.map(&:strip)

UNKN = ??
ROOM = ?.
WALL = ?#
VERT = ?|
HORZ = ?–
ME = ?X

NEW_DOOR = "#?#"
NEW_ROOM = "?.?"

def print(map)
  puts; map.each { |l| puts l unless l == ' ' * l.size }
end

def chunks(regex)
  l = ['']
  depth = 0
  regex.chars.each do |c|
    case c
    when ?(
      depth += 1
    when ?)
      depth -= 1
    end

    if c == ?| && depth == 0
      l << ''
    else
      l.last << c
    end
  end
  l
end

def close_index(regex)
  depth = 0
  regex.chars.each.with_index do |c, i|
    case c
    when ?(
      depth += 1
    when ?)
      depth -= 1
      return i if depth == 0
    end
  end

  raise 'end close_index'
end

def parse_chunk(regex, yc, xc, map)
  i = 0
  until i >= regex.size
    map[yc][xc] = ME
    # print(map)
    map[yc][xc] = ROOM

    case regex[i]
    when ?(
      close = i + close_index(regex[i..-1])
      parse_regex(regex[i + 1..close - 1], yc, xc, map)
      i = close
    when ?N
      map[yc - 1][xc] = HORZ
      if map[yc - 2][xc] == ' '
        map[yc - 2].rep(NEW_ROOM, xc - 1)
        map[yc - 3].rep(NEW_DOOR, xc - 1)
      end
      yc -= 2
    when ?S
      map[yc + 1][xc] = HORZ
      if map[yc + 2][xc] == ' '
        map[yc + 2].rep(NEW_ROOM, xc - 1)
        map[yc + 3].rep(NEW_DOOR, xc - 1)
      end
      yc += 2
    when ?E
      map[yc][xc + 1] = VERT
      if map[yc][xc + 2] == ' '
        map[yc - 1][xc + 2] = UNKN
        map[yc][xc + 2] = ROOM
        map[yc + 1][xc + 2] = UNKN
        map[yc - 1][xc + 3] = WALL
        map[yc][xc + 3] = UNKN
        map[yc + 1][xc + 3] = WALL
      end
      xc += 2
    when ?W
      map[yc][xc - 1] = VERT
      if map[yc][xc - 2] == ' '
        map[yc - 1][xc - 2] = UNKN
        map[yc][xc - 2] = ROOM
        map[yc + 1][xc - 2] = UNKN
        map[yc - 1][xc - 3] = WALL
        map[yc][xc - 3] = UNKN
        map[yc + 1][xc - 3] = WALL
      end
      xc -= 2
    end

    i += 1
  end
end

def parse_regex(regex, yc, xc, map)
  chunks(regex).each do |chunk|
    parse_chunk(chunk, yc, xc, map)
  end
end

def adjacent_rooms(map, start_y, start_x)
  squares = Set.new
  squares << [start_y - 2, start_x] if map[start_y - 1][start_x] == HORZ
  squares << [start_y + 2, start_x] if map[start_y + 1][start_x] == HORZ
  squares << [start_y, start_x + 2] if map[start_y][start_x + 1] == VERT
  squares << [start_y, start_x - 2] if map[start_y][start_x - 1] == VERT
  squares
end

def most_doors(map, start_y, start_x)
  reached = Set.new
  num = 0
  stack = [[start_y, start_x, 0]]
  until stack.empty?
    y, x, steps = stack.shift
    reached << [y, x]
    rooms = adjacent_rooms(map, y, x) - reached
    num += 1 if steps >= 1000
    rooms.each do |room|
      stack << [*room, steps + 1]
    end
  end
  num
end

SIZE = 1000
map = Array.new(SIZE) { ' ' * SIZE }
map[SIZE / 2 - 1].rep(NEW_DOOR, SIZE / 2 - 1)
map[SIZE / 2].rep(NEW_ROOM, SIZE / 2 - 1)
map[SIZE / 2 + 1].rep(NEW_DOOR, SIZE / 2 - 1)

start_y = SIZE / 2
start_x = SIZE / 2
parse_regex(lines[0][1..-2], start_y, start_x, map)
map[start_y][start_x] = ME
map.each { |l| l.gsub!(UNKN, WALL) }

print(map)

puts most_doors(map, start_y, start_x)
