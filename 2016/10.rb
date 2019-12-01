require_relative 'util'
lines = $stdin.read.strip.split("\n")

bots = Hash.new { |h, k| h[k] = [] }
output = Hash.new { |h, k| h[k] = [] }

starts, instr = lines.partition { |line| line.start_with?('value') }

starts.each do |line|
  words = line.split
  bots[words.last.to_i] << words[1].to_i
end
  
instr.cycle do |line|
  words = line.split

  bot = words[1].to_i
  vals = bots[bot]
  next unless vals.size == 2

  vals.sort!
  # (p bot; exit) if vals == [17, 61] 

  [5, 10].each do |i|
    (words[i] == 'output' ? output : bots)[words[i + 1].to_i] << vals.shift
  end

  if bots.values.all? { |v| v.size < 2 }
    p output[0][0].to_i * output[1][0].to_i * output[2][0].to_i
    exit
  end
end
