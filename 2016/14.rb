require_relative 'util'
lines = $stdin.read.chomp.split("\n")

require 'digest'

input = lines[0]
hashes = []
keys = []

(0..).each do |idx|
  s = input + idx.to_s
  2017.times { s = Digest::MD5.hexdigest(s) }
  hashes << s
  next if hashes.size < 1001

  prev = hashes.shift
  char_idx =
    (0..prev.size - 3).find do |i|
      prev[i] == prev[i + 1] && prev[i] == prev[i + 2]
    end
  next unless char_idx

  char = prev[char_idx]

  # p "triplet: #{idx - 1000} #{char} #{prev}"
  five_chars = char * 5
  char_idx =
    hashes.any? do |hash|
      (0..hash.size - 5).find { |i| hash[i..i + 4] == five_chars }
    end
  next unless char_idx

  keys << hash
  p "success #{keys.size}"
  if keys.size == 64
    (
      p idx - 1000
      exit
    )
  end
end
