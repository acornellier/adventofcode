require_relative 'util'

input = File.read(ARGV[0])
lines = input.split("\n").map(&:chomp)

adapters = lines.map(&:to_i)
rating = adapters.max + 3
adapters = ([0] + adapters + [rating]).sort

diffs = Hash.new(0)

prev = 0
adapters.each do |adapter|
  diffs[adapter - prev] += 1
  prev = adapter
end

p diffs[1] * diffs[3]

@paths_to_end = { rating => 1 }

reverse = adapters.reverse
reverse.each.with_index do |adapter, idx|
  next if idx == 0
  start = [idx - 3, 0].max
  potential =
    reverse[start...idx].select { |n| n > adapter && n <= adapter + 3 }
  @paths_to_end[adapter] = potential.sum { |n| @paths_to_end.fetch(n) }
end

p @paths_to_end[0]
