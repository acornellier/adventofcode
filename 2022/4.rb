require_relative 'input'

lines = get_input_str_arr(__FILE__)

p(lines.count do |l|
  pairs = l.split(',').map do
    a, b = _1.split('-')
    (a.to_i..b.to_i)
  end

  !(pairs[0] & pairs[1]).empty?
end)
