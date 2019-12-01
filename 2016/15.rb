require_relative 'util'
lines = $stdin.read.chomp.split("\n")

discs = lines.map do |line|
  line.match(/(\d+) positions; at time=(\d+), it is at position (\d+)/)[1..].map(&:to_i)
end

(0..).each do |start_time|
  p start_time

  capsule = 0
  until capsule >= discs.size
    capsule += 1
    disc = discs[capsule - 1]
    unless (disc[2] + start_time + capsule) % disc[0] == 0
      capsule = - 1
      break
    end
  end
    
  exit unless capsule == -1
end