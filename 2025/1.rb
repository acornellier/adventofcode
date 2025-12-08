require_relative 'util'
require_relative 'input'

@example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

zero = 0
cur = 50
lines.each do |line|
  dir = line[0] == 'R' ? +1 : -1
  dist = line[1..].to_i
  rotations, mod = dist.divmod(100)
  signed_mod = mod * dir

  zero += rotations
  zero += 1 if cur != 0 && (cur + signed_mod <= 0 || cur + signed_mod >= 100)

  cur = (cur + dist * dir) % 100
end

p zero
