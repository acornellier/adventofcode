require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

line = get_input_str_arr(__FILE__)[0]

invalid_sum = 0
line.split(',').each do |r|
  a, b = r.split('-')
  (a..b).each do |n|
    (1..n.size / 2).each do |m|
      next unless n.size % m == 0
      parts = n.chars.each_slice(m).to_a
      if parts.uniq.size == 1
        invalid_sum += n.to_i
        break
      end
    end
  end
end

p invalid_sum
