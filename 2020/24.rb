require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
lines = get_input_str_arr(__FILE__)

def transpose(pos, dir)
  transposes = {
    'e' => [1, 0, -1],
    'se' => [0, 1, -1],
    'sw' => [-1, 1, 0],
    'w' => [-1, 0, 1],
    'nw' => [0, -1, 1],
    'ne' => [1, -1, 0],
  }
  pos.zip(transposes[dir]).map { |c, dc| c + dc }
end

def count_neighbors(flipped_tiles, pos)
  transposes = [
    [1, 0, -1],
    [0, 1, -1],
    [-1, 1, 0],
    [-1, 0, 1],
    [0, -1, 1],
    [1, -1, 0],
  ]
  transposes
    .map { |t| pos.zip(t).map { |c, dc| c + dc } }
    .count { |p| flipped_tiles.include?(p) }
end

flipped_tiles = Set.new # [x,y,z]
lines.each do |line|
  pos =
    line.scan(/[ns]?[ew]/).reduce([0, 0, 0]) { |pos, dir| transpose(pos, dir) }
  flipped_tiles.delete?(pos) || flipped_tiles.add(pos)
end

puts "Day 0: #{flipped_tiles.size}"
100.times do |i|
  min_x, max_x = flipped_tiles.map { |p| p[0] }.minmax
  min_y, max_y = flipped_tiles.map { |p| p[1] }.minmax
  min_z, max_z = flipped_tiles.map { |p| p[2] }.minmax

  new_flipped_tiles = Set.new
  (min_x - 1..max_x + 1).each do |x|
    (min_y - 1..max_y + 1).each do |y|
      (min_z - 1..max_z + 1).each do |z|
        p = [x, y, z]
        neighbors = count_neighbors(flipped_tiles, p)
        if flipped_tiles.include?(p)
          new_flipped_tiles.add(p) if neighbors == 1 || neighbors == 2
        else
          new_flipped_tiles.add(p) if neighbors == 2
        end
      end
    end
  end

  flipped_tiles = new_flipped_tiles
  puts "Day #{i + 1}: #{flipped_tiles.size}"
end
