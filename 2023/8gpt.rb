#!/usr/bin/env ruby

def parse_input(input)
  lines = input.strip.split("\n")
  instructions = lines[0].chars

  network = {}
  lines[2..].each do |line|
    if line =~ /(\w+) = \((\w+), (\w+)\)/
      network[$1] = { 'L' => $2, 'R' => $3 }
    end
  end

  [instructions, network]
end

def part1(input)
  instructions, network = parse_input(input)

  current = 'AAA'
  steps = 0
  instruction_index = 0

  until current == 'ZZZ'
    direction = instructions[instruction_index]
    current = network[current][direction]
    steps += 1
    instruction_index = (instruction_index + 1) % instructions.length
  end

  steps
end

def part2(input)
  instructions, network = parse_input(input)

  # Find all starting nodes (ending with 'A')
  starting_nodes = network.keys.select { |node| node.end_with?('A') }

  # For each starting node, find how many steps to reach a node ending with 'Z'
  cycle_lengths = starting_nodes.map do |start|
    current = start
    steps = 0
    instruction_index = 0

    until current.end_with?('Z')
      direction = instructions[instruction_index]
      current = network[current][direction]
      steps += 1
      instruction_index = (instruction_index + 1) % instructions.length
    end

    steps
  end

  # The answer is the LCM of all cycle lengths
  cycle_lengths.reduce(1) { |lcm, length| lcm.lcm(length) }
end

# Test with the examples
example1 = <<~INPUT
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
INPUT

example2 = <<~INPUT
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
INPUT

example3 = <<~INPUT
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
INPUT

puts "Part 1 Example 1: #{part1(example1)} (expected 2)"
puts "Part 1 Example 2: #{part1(example2)} (expected 6)"
puts "Part 2 Example: #{part2(example3)} (expected 6)"
puts

# Read actual input if available
if File.exist?('8.input')
  input = File.read('8.input')
  puts "Part 1: #{part1(input)}"
  puts "Part 2: #{part2(input)}"
else
  puts "Place your puzzle input in '8.input' to solve"
end