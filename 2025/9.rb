require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

reds = lines.map { _1.split(',').map(&:to_i) }
greens = (reds + [reds[0]]).each_cons(2)

reds.combination(2).sort_by do |(x1, y1), (x2, y2)|
  (y2 - y1).abs * (x2 - x1).abs
end.reverse.each do |(x, y), (u, v)|
  x, u = u, x if x > u
  y, v = v, y if y > v

  good = greens.none? do |(p, q), (r, s)|
    p, r = r, p if p > r
    q, s = s, q if q > s
    p < u && q < v && r > x && s > y
  end

  if good
    p (u - x + 1).abs * (v - y + 1).abs
    exit
  end
end
