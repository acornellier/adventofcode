require_relative 'util'

# input = File.read('./ejemplo.txt')
input = File.read('input.txt')
lines = input.split("\n").map(&:chomp)

numbers = lines[0].split(',').map(&:to_i)
last_spoken_turn = numbers[0..-2].map.with_index(1) { |n, i| [n, i] }.to_h
turn = numbers.size
cur_number = numbers.last

until turn == 30_000_000
  prev_time = last_spoken_turn[cur_number]
  last_spoken_turn[cur_number] = turn
  cur_number = prev_time.nil? ? 0 : turn - prev_time
  turn += 1
end

p cur_number
