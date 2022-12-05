p $<.map(&:to_i).chunk { _1 > 0 }.map { _2.sum }.max(3).sum
