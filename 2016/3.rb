require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

res = lines.map do |line|
  line.split.map(&:to_i)
end.each_slice(3).flat_map(&:transpose).count do |a, b, c|
  a + b > c && a + c > b && b + c > a
end

p res