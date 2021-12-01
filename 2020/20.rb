require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
groups = str_groups_separated_by_blank_lines(__FILE__)

def draw(tile)
  puts tile.map(&:join)
end

def rotations(tile)
  res = [tile]
  3.times { res << res[-1].transpose.map(&:reverse) }
  res
end

def variants(tile)
  res = rotations(tile)
  res += rotations(tile.reverse)
  res += rotations(res[0].transpose.reverse.transpose)
  res.uniq
end

@tiles =
  groups.to_h do |group|
    title, rest = group[0], group[1..]
    tile_id = title.match(/\d+/)[0].to_i
    tile = rest.map(&:chars)
    [tile_id, variants(tile)]
  end
@dim = Math.sqrt(@tiles.size).to_i

# [y, x] => [tile_id, variant_idx]
full_image = {}

@visited_images = []

def dfs_images(image, tiles, y, x)
  return image if image.size == @tiles.size

  top_id, top_variant_idx = image[[y - 1, x]]
  top = @tiles.dig(top_id, top_variant_idx)
  left_id, left_variant_idx = image[[y, x - 1]]
  left = @tiles.dig(left_id, left_variant_idx)

  tiles.each do |tile_id, variants|
    variants.each.with_index do |variant, idx|
      unless (top.nil? || top[-1] == variant[0]) &&
               (left.nil? || left.transpose[-1] == variant.transpose[0])
        next
      end

      new_image = image.dup
      new_image[[y, x]] = [tile_id, idx]
      new_x = (x + 1) % @dim
      new_tiles = tiles.dup
      new_tiles.delete(tile_id)
      res = dfs_images(new_image, new_tiles, new_x == 0 ? y + 1 : y, new_x)
      return res if res
    end
  end

  return false
end

image = dfs_images(full_image, @tiles, 0, 0)
raise unless image
puts [
       image[[0, 0]][0],
       image[[0, @dim - 1]][0],
       image[[@dim - 1, 0]][0],
       image[[@dim - 1, @dim - 1]][0],
     ].inject(:*)

final_image = []
(0...@dim).each do |y|
  lines = []
  (0...@dim).each do |x|
    tile_id, variant_idx = image[[y, x]]
    tile = @tiles[tile_id][variant_idx]
    tile[1..-2].each.with_index do |line, index|
      (lines[index] ||= '') << line[1..-2].join
    end
  end
  final_image += lines.map(&:chars)
end

monster =
  ['                  # ', '#    ##    ##    ###', ' #  #  #  #  #  #   '].map(
    &:chars
  )

data = final_image

def check(data, monster)
  match = false
  (0...data.length - monster.length).each do |r|
    (0...data.first.length).each do |c|
      # is there a monster here?
      copy = data.map(&:dup)
      n = 0
      (0...monster.length).each do |r2|
        (0...monster.first.length).each do |c2|
          if monster[r2][c2] == '#' && copy[r + r2][c + c2] == '#'
            copy[r + r2][c + c2] = 'O'
            n += 1
          end
        end
      end

      # if we found a monster, make sure we use the new state from here on out
      if n == 15
        match = true
        data = copy
      end
    end
  end

  if match
    p data.map(&:join).join.chars.count { |i| i == '#' }
    exit
  end
end

2.times do
  # original
  check(data, monster)

  # rotate 3 times
  3.times { check(data = data.transpose.map(&:reverse), monster) }

  # flip
  data = data.reverse
end

p 'fail'
