require_relative 'util'
lines = $stdin.read.strip.split("\n")

pairs =
  lines.map { |line| line.match(%r{(\d+)\/(\d+)})[1..].map(&:to_i).sort }.sort

def strongest(pairs, available_port, length)
  pairs.map do |pair|
    idx = pair.index(available_port)
    next [length, 0] unless idx
    total_length, strength =
      strongest(pairs - [pair], pair[(idx + 1) % 2], length + 1)
    [total_length, pair.sum + strength]
  end.max
end

puts strongest(pairs, 0, 0)
