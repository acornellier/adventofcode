n=gets.split(?,).map &:to_i
p (0..n.max).map{|u|n.sum{(1..(_1-u).abs).sum}}.min