require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

line = get_input_str_arr(__FILE__)[0]

invalid_sum = 0
line.split(',').each do |r|
  a, b = r.split('-')
  (a..b).each do |n|
    invalid_sum += n.to_i if n.match? /^(\d+)\1+$/
  end
end

p invalid_sum
