require_relative 'util'
lines = $stdin.read.strip.split("\n")

diagnostic = lines[1].match(/\d+/)[0].to_i

rules = {}

3
  .step(nil, 10)
  .each do |n|
    break unless lines[n]
    state = lines[n].match(/state (\w):/)[1]
    rules[state] = { 0 => [], 1 => [] }

    write0 = lines[n + 2][-2].to_i
    move0 = lines[n + 3].match(/to the (\w+)./)[1]
    cont0 = lines[n + 4][-2]

    write1 = lines[n + 6][-2].to_i
    move1 = lines[n + 7].match(/to the (\w+)./)[1]
    cont1 = lines[n + 8][-2]

    rules[state][0] = [write0, move0, cont0]
    rules[state][1] = [write1, move1, cont1]
  end

state = 'A'
tape = Hash.new(0)
idx = 0

(0...diagnostic).each do
  rule = rules[state][tape[idx]]
  tape[idx] = rule[0]
  idx += rule[1] == 'right' ? +1 : -1
  state = rule[2]
end

puts tape.values.count { |n| n == 1 }
