require_relative 'util/grid'
lines = $stdin.read.chomp.split("\n")

CLEAN = '.'
WEAKENED = 'W'
INFECTED = '#'
FLAGGED = 'F'
STATE_CHANGE = {
  CLEAN => WEAKENED,
  WEAKENED => INFECTED,
  INFECTED => FLAGGED,
  FLAGGED => CLEAN,
}

grid = Grid.new(lines, lines.size / 2, lines.size / 2, UP)
bursts_infected = 0

start = Time.now
10_000_000.times do |n|
  # grid.draw
  puts n if n % 1_000_000 == 0

  case grid.cur
  when INFECTED
    grid.turn_right
  when CLEAN
    grid.turn_left
  when FLAGGED
    grid.turn_around
  end

  grid.cur = STATE_CHANGE[grid.cur]
  bursts_infected += 1 if grid.cur == INFECTED

  grid.move

  if grid.y < 0
    grid.g.prepend('.' * grid[0].size)
    grid.y = 0
  elsif grid.y == grid.g.size
    grid.g.push('.' * grid[0].size)
  elsif grid.x < 0
    grid.g.each { |r| r.prepend('.') }
    grid.x = 0
  elsif grid.x == grid[0].size
    grid.g.each { |r| r << '.' }
  end
end

p bursts_infected
p Time.now - start
