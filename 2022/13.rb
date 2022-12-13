def compare(x, y)
  case [x, y]
  in [Integer, Integer]
    x <=> y
  in [Array, Array]
    (0...[x.size, y.size].min).each do |i|
      res = compare(x[i], y[i])
      return res if res != 0
    end
    x.size <=> y.size
  else
    compare([x].flatten(1), [y].flatten(1))
  end
end

dividers = [[[2]], [[6]]]
packets = $<.reject { _1 == ?\n }.map(&method(:eval)) + dividers
packets.sort!(&method(:compare))

p dividers.map { packets.index(_1) + 1 }.inject(:*)
