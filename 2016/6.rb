require_relative 'util'
lines = $stdin.read.strip.split("\n")

floating_address =
  lines
    .map { |s| s.chars }
    .transpose
    .map { |column| column.group_by(&:itself).sort_by { |k, v| v.size }[0][0] }
    .join

p floating_address
