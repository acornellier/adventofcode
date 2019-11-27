require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

res = lines.map { |s| s.chars }.transpose.map do |column|
  column.group_by(&:itself).sort_by { |k, v| v.size }[0][0]
end.join

p res
