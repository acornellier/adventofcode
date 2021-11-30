require_relative 'util'
lines = $stdin.read.strip.split("\n")

floating_address =
  lines
    .map { |line| line.split.map(&:to_i) }
    .each_slice(3)
    .flat_map(&:transpose)
    .count { |a, b, c| a + b > c && a + c > b && b + c > a }

p floating_address
