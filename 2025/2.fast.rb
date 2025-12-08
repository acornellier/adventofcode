require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

line = get_input_str_arr(__FILE__)[0]

invalids = Set.new
('1'..'99_999').each do |s|
  max_repeats = 10 / s.size
  (2..max_repeats).each do |repeats|
    invalids << (s * repeats).to_i
  end
end

invalid_sum = 0
line.split(',').each do |r|
  a, b = r.split('-').map(&:to_i)
  (a..b).each do |n|
    invalid_sum += n if invalids.include?(n)
  end
end

p invalid_sum
