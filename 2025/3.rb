require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

p(lines.map(&:chars).sum do |digits|
  12.times.map do |n|
    digit = digits[..-(12 - n)].max
    index = digits.index(digit)
    digits = digits[index + 1..]
    digit
  end.join.to_i
end)
