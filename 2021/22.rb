require_relative 'util'
require_relative 'input'

@example_extension = 'ex3'

lines = get_input_str_arr(__FILE__)

g = {}

region = [1..5, 3..7, -939..111]

lines.each do |line|
  instr, rest = line.split
  ranges = rest.split(',').map { eval(_1[2..]) }

  ranges[0].each do |x|
    ranges[1].each do |y|
      ranges[2].each do |z|
        g[[x, y, z]] = instr == 'on'
      end
    end
  end
end

p g.values.count { _1 }
