require_relative 'util'
require_relative './input'

@example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)

copies = Array.new(lines.size, 1)
lines.each.with_index do |line, idx|
  _, rest = line.split(':')
  winning, mine = rest.split(?|).map { _1.scan(/\d+/).map(&:to_i) }
  matched = (mine & winning).size

  1.upto(matched) do |offset|
    copies[idx + offset] += copies[idx] if offset < copies.size
  end
end

p copies.sum

