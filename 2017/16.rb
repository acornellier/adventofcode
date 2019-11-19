lines = $stdin.read.strip.split("\n")

moves = lines[0].split(',')

# g = ('a'..'e').to_a
g = ('a'..'p').to_a
og = g.dup

positions = [g.dup]

n = 0
loop do
  moves.each do |move|
    case move[0]
    when 's'
      size = move[1..].to_i
      g.rotate!(-size)
    when 'x'
      m = move.match(/x(\d+)\/(\d+)/)
      a = m[1].to_i
      b = m[2].to_i
      temp = g[a]
      g[a] = g[b]
      g[b] = temp
    when 'p'
      p = move[1]
      q = move[3]
      a = g.index(p)
      b = g.index(q)
      temp = g[a]
      g[a] = g[b]
      g[b] = temp
    end
  end

  positions << g.dup
  n += 1
  break if g == og
end

puts positions.map(&:join)
puts 1000000000%n
p positions[34].join