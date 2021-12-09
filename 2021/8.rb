require_relative 'util'
require_relative 'input'

# @example_extension = 'ex2'

lines = get_input_str_arr(__FILE__)

segments = %w[abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg]
permutations = 'abcdefg'.chars.permutation.map(&:join)

sum =
  lines.sum do |x|
    signals, output = x.split(' | ').map(&:split)
    correct =
      permutations.find do |perm|
        signals.map { |signal| signal.tr(perm, 'abcdefg').chars.sort.join }
          .sort == segments.sort
      end
    mapping = segments.map { _1.tr('abcdefg', correct).chars.sort.join }
    output.map { mapping.index(_1.chars.sort.join) }.join.to_i
  end

p sum
