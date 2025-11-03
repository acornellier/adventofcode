require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)
# @type [Array<Array<String>>]
# groups = str_groups_separated_by_blank_lines(__FILE__)

time = lines[0].scan(/\d+/).join.to_i
distance = lines[1].scan(/\d+/).join.to_i

ways = (0..time).count do |time_held|
  time_left = time - time_held
  speed = time_held
  distance_covered = speed * time_left
  distance_covered > distance
end

p ways
