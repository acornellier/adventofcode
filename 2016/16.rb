require_relative 'util/grid'
lines = $stdin.read.chomp.split("\n")

disk_size = lines[0].to_i
data = lines[1]

data += '0' + data.reverse.gsub(/./, '0' => '1', '1' => '0') until data.size >= disk_size
data = data[0...disk_size].chars
data = data.each_slice(2).map { |a, b| a == b ? '1' : '0' } until data.size.odd?

puts data.join
