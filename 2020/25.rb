require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
# lines = get_input_str_arr(__FILE__)

card = 16_616_892
door = 14_505_727

# card = 5_764_801
# door = 17_807_724

def find_loop_size(public_key)
  value = 1
  (1..).find do |loop_size|
    value = value * 7 % 20_201_227
    value == public_key
  end
end

card_loop_size = find_loop_size(card)
door_loop_size = find_loop_size(door)

encryption_key = 1
card_loop_size.times { encryption_key = encryption_key * door % 20_201_227 }
p encryption_key
