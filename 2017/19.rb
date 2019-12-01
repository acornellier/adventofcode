require_relative 'util'
lines = $stdin.read.chomp.split("\n")

grid = Util.new(lines, 0, lines[0].index('|'), DOWN)

path = []
steps = 0

loop do
  steps += 1
  grid.move
  # grid.draw

  case grid.cur
  when '+'
    if grid.dir == UP || grid.dir == DOWN
      grid.dir = grid.neighbor(LEFT).match?(/\w|-/) ? LEFT : RIGHT
    else
      grid.dir = grid.neighbor(UP).match?(/\w|\|/) ? UP : DOWN
    end
  when /\w/
    path << grid.cur
  when /\s/
    p path.join, steps
    exit
  end
end
