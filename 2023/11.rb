require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)
lines = lines.map(&:chars)

y_gaps = []
x_gaps = []

2.times do |n|
  idx = 0
  while idx < lines.size
    if lines[idx].all?('.')
      if n == 0
        y_gaps << idx
      else
        x_gaps << idx
      end
    end
    idx += 1
  end
  lines = lines.transpose
end

galaxies = (0...lines.size).flat_map do |y|
  (0...lines[0].size).filter_map do |x|
    [y, x] if lines[y][x] == '#'
  end
end

gap_size = 1_000_000
res = galaxies.map.with_index do |(y0, x0), idx1|
  galaxies[idx1 + 1..].sum do |y2, x2|
    x1, x2 = [x0, x2].sort
    y1, y2 = [y0, y2].sort
    y_dist = (y2 - y1) + (gap_size - 1) * y_gaps.count { |yg| y1 < yg && yg < y2 }
    x_dist = (x2 - x1) + (gap_size - 1) * x_gaps.count { |xg| x1 < xg && xg < x2 }
    y_dist + x_dist
  end
end.sum

p res
