require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

line = get_input_str(__FILE__)

def hasher(s)
  cur = 0
  s.chars.each do |c|
    cur += c.ord
    cur *= 17
    cur %= 256
  end
  cur
end

boxes = Hash.new { |hash, key| hash[key] = [] }
line.split(',').each do |command|
  label, op, length = command.partition(/[-=]/)
  length = length.to_i
  box = hasher(label)
  if op == '-'
    boxes[box].reject! { _1[0] == label }
  else
    matching = boxes[box].find { _1[0] == label }
    if matching
      matching[1] = length
    else
      boxes[box] << [label, length]
    end
  end
end

power = boxes.sum do |box, lenses|
  lenses.map.with_index do |(label, length), index|
    (1 + box) * (index + 1) * length
  end.sum
end

p power
