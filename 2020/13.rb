require_relative 'util'

# input = File.read('./ejemplo.txt')
input = File.read('input.txt')
lines = input.split("\n").map(&:chomp)

earliest_timestamp = lines[0].to_i
buses = lines[1].split(',').select { |n| n != 'x' }.map(&:to_i)

(earliest_timestamp..).each do |timestamp|
  buses.each do |bus|
    if timestamp % bus == 0
      p timestamp
      p bus
      p (timestamp - earliest_timestamp) * bus
      exit
    end
  end
end
