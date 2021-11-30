require_relative 'util'

lines = File.readlines(ARGV[0]).map(&:chomp)

bin = ->(s) { s.tr('FBLR', '0101').to_i(2) }

sids = lines.map { |line| 8 * bin[line[0..6]] + bin[line[7..]] }

p((sids.min..sids.max).to_a - sids)
