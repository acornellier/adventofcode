require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__).map(&:chars)

height = lines.size
width = lines[0].size

tilt = ->(dir) do
  lines = lines.transpose if dir == LEFT || dir == RIGHT
  lines = lines.reverse if dir == DOWN || dir == RIGHT
  (0..height - 1).each do |y|
    (0..width - 1).each do |x|
      cur = lines[y][x]
      next unless cur == '.'

      (y + 1..height - 1).each do |y2|
        cur2 = lines[y2][x]
        break if cur2 == '#'
        next unless cur2 == 'O'

        lines[y][x] = 'O'
        lines[y2][x] = '.'
        break
      end
    end
  end
  lines = lines.reverse if dir == DOWN || dir == RIGHT
  lines = lines.transpose if dir == LEFT || dir == RIGHT
end

load = ->() do
  lines.map.with_index do |line, y|
    line.count('O') * (height - y)
  end.sum
end

cycles = 0
seen = {}
found = false
total_cycles = 1000000000
while cycles < total_cycles
  [UP, LEFT, DOWN, RIGHT].each do |dir|
    tilt.call(dir)
  end
  cycles += 1

  p "cycle #{cycles}"

  unless found
    v = lines.sum(&:hasher)
    if seen.key?(v)
      cycle_len = cycles - seen[v]
      cycles += (total_cycles - cycles) / cycle_len * cycle_len
      found = true
      p "found at #{cycles}"
    else
      seen[v] = cycles
    end
  end
end

p load.call
