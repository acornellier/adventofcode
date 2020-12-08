require_relative 'util'

input = File.read(ARGV[0])
lines = input.split("\n").map(&:chomp)

map = {}

lines.each do |line|
  color, _, rest = line.partition(' bags contain ')
  if line.include?('no other bags')
    map[color] = []
    next
  end

  others = rest.split(', ').map do |rem|
    rest2 = rem.split(' ')
    [rest2[0].to_i, rest2[1..2].join(' ')]
  end
  map[color] = others
end

valid_color = ->(color) do
  map[color].any? do |other_count, other_color|
    other_color == 'shiny gold' || valid_color[other_color]
  end
end

p map.keys.count { |color| valid_color[color] }

num_bags = ->(color) do
  1 + map[color].sum do |other_count, other_color|
    other_count * num_bags[other_color]
  end
end

p num_bags['shiny gold'] - 1
