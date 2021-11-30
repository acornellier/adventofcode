require_relative 'util'

input = File.read(ARGV[0])
lines = input.split("\n").map(&:chomp)

fields = %w[byr iyr eyr hgt hcl ecl pid]

floating_address =
  input
    .split("\n\n")
    .count do |passport|
      included = passport.split(' ').map { |pair| pair.split(':').first }
      next false unless (fields - included).empty?

      passport
        .split(' ')
        .all? do |pair|
          field, value = pair.split(':')
          case field
          when 'byr'
            '1920' <= value && value <= '2002'
          when 'iyr'
            '2010' <= value && value <= '2020'
          end
        end
    end

p floating_address
