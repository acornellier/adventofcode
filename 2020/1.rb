require_relative 'util'

lines = File.readlines(ARGV[0])

p lines.map(&:to_i).combination(3).find { |n| n.sum == 2020 }.reduce(:*)
