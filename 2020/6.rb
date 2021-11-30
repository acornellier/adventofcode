require_relative 'util'

input = File.read(ARGV[0])
lines = input.split("\n").map(&:chomp)

floating_address =
  input
    .split("\n\n")
    .sum do |group|
      questions = group.scan(/\w/).uniq
      questions.count do |question|
        group.split("\n").all? { |person| person.include?(question) }
      end
    end

p floating_address
