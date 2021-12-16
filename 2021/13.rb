points, folds = File.read('13.input').split("\n\n")

points = points.lines.map {|coords| coords.split(',').map(&:to_i) }
folds = folds.lines.map {|fold| fold.match(/(x|y)=(\d+)$/).captures }

max_x = points.collect(&:first).max
max_y = points.collect(&:last).max

grid = []
(max_y + 1).times { grid << Array.new(max_x + 1, 0) }

points.each {|x,y| grid[y][x] = 1 }

def fold(grid, dir, index)
  m = dir == 'x' ? grid.map {|row| row[...index] } : grid[...index]
  n = dir == 'x' ? grid.map {|row| row[index...].reverse } : grid[index...].reverse
  m.zip(n).map {|m_row,n_row| m_row.zip(n_row).map(&:max) } 
end

dir, index = folds.shift
grid = fold(grid, dir, index.to_i)

puts "Part 1: #{grid.map(&:sum).sum}"

folds.each do |dir,index|
  grid = fold(grid, dir, index.to_i)
end

puts "Part 2:"
grid.each {|row| row.each {|col| print col == 1 ? '#' : ' ' }; print "\n" }