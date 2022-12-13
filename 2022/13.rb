def compare(x, y)
  case [x, y]
  in [NilClass, _]
    -1
  in [_, NilClass]
    1
  in [Integer, Integer]
    x < y ? -1 : x > y ? 1 : 0
  in [Array, Array]
    (0...[x.size, y.size].max).each do |i|
      res = compare(x[i], y[i])
      return res if res != 0
    end
    0
  else
    compare([x].flatten(1), [y].flatten(1))
  end
end

dividers = [[[2]], [[6]]]
packets = $<.reject { _1 == ?\n }.map { eval(_1) } + dividers
packets.sort! { compare(_1, _2) }

p dividers.map { packets.index(_1) + 1 }.inject(:*)
