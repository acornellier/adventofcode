require_relative 'util'

# input = File.read('./ejemplo.txt')
input = File.read('input.txt')
lines = input.split("\n").map(&:chomp)

memory = {}
mask = ''

lines.each do |line|
  if line.start_with?('mask = ')
    mask = line.split('mask = ')[1]
    next
  end

  match = line.match(/mem\[(\d+)\] = (\d+)/)
  address, value = match[1..].map(&:to_i)

  binary_address = address.to_s(2).rjust(mask.size, '0')
  floating_address =
    binary_address
      .chars
      .map
      .with_index do |char, idx|
        case mask[idx]
        when '0'
          char
        when '1'
          '1'
        when 'X'
          'X'
        else
          throw
        end
      end
      .join

  x_count = floating_address.count('X')
  %w[0 1].repeated_permutation(x_count).map do |bits|
    bits = bits.join.chars
    index = 0
    new_address =
      floating_address
        .chars
        .map do |char|
          next char if char != 'X'
          index += 1
          bits[index - 1]
        end
        .join
        .to_i(2)

    memory[new_address] = value
  end
  p memory.values.sum
end

p memory.values.sum
