require_relative 'util'

input = File.read(ARGV[0])
lines = input.split("\n").map(&:chomp)
