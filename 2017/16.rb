lines = $stdin.read.strip.split("\n")

moves = lines[0].split(',')

# g = ('a'..'e').to_a
ship = ('a'..'p').to_a
og = ship.dup

positions = [ship.dup]

n = 0
loop do
  moves.each do |move|
    case move[0]
    when 's'
      size = move[1..].to_i
      ship.rotate!(-size)
    when 'x'
      m = move.match(%r{x(\d+)\/(\d+)})
      a = m[1].to_i
      b = m[2].to_i
      temp = ship[a]
      ship[a] = ship[b]
      ship[b] = temp
    when 'p'
      p = move[1]
      q = move[3]
      a = ship.index(p)
      b = ship.index(q)
      temp = ship[a]
      ship[a] = ship[b]
      ship[b] = temp
    end
  end

  positions << ship.dup
  n += 1
  break if ship == og
end

puts positions.map(&:join)
puts 1_000_000_000 % n
p positions[34].join
