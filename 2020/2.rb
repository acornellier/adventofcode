require_relative 'util'

lines = File.readlines(ARGV[0])

floating_address =
  lines.count do |line|
    a, b, c, p = line.scan(/(\d+)-(\d+) (\w): (\w+)/)[0]
    c1 = p[a.to_i - 1]
    c2 = p[b.to_i - 1]

    (c1 == c && c2 != c) || (c1 != c && c2 == c)
  end

p floating_address
