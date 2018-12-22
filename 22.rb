require 'pry'

i = File.readlines('../input.txt')
e = File.readlines('example.txt')

lines = i.map(&:strip)

depth = lines[0].split(' ').last.to_i
target_x, target_y = lines[1].split(' ').last.split(',').map(&:to_i)

PADDING = 1000
erosion = Array.new(target_y + PADDING) { Array.new(target_x + PADDING, nil) }
gindex = Array.new(target_y + PADDING) { Array.new(target_x + PADDING, nil) }

gindex[target_y][target_x] = 0
erosion[target_y][target_x] = (0 + depth) % 20183

(0...gindex.first.size).each do |x|
  gindex[0][x] = 16807 * x
  erosion[0][x] = (gindex[0][x] + depth) % 20183
end

(0...gindex.size).each do |y|
  gindex[y][0] = 48271 * y
  erosion[y][0] = (gindex[y][0] + depth) % 20183
end 

(1...gindex.size).each do |y|
  (1...gindex.first.size).each do |x|
    next if y == target_y && x == target_x
    gindex[y][x] = erosion[y][x-1] * erosion[y-1][x]
    erosion[y][x] = (gindex[y][x] + depth) % 20183
  end
end

res = erosion[0..target_y].sum do |r|
  r[0..target_x].sum do |c|
    c % 3
  end
end

p res

TORCH = 1

grid = erosion.map do |r|
  r.map { |c| c % 3 }
end

require 'pqueue'
pq = PQueue.new { |a,b| a[0] < b[0] }
pq.push([0, 0, 0, TORCH])
best = {}
until pq.empty? do
  p pq.size if pq.size % 1000 == 0
  min, y, x, item = pq.pop

  key = [y,x,item]
  next if best[key] && min >= best[key]
  best[key] = min
  if key == [target_y, target_x, TORCH]
    p min
    exit
  end

  (0..2).each do |i|
    pq.push([min + 7, y, x, i]) if i != item && i != grid[y][x]
  end

  [[-1,0], [1,0], [0,-1], [0,1]].each do |(dy, dx)|
    y2 = y + dy
    x2 = x + dx
    next unless y2 >= 0 && grid[y2] && x2 >= 0 && grid[y2][x2]
    next if grid[y2][x2] == item
    pq.push([min + 1, y2, x2, item])
  end
end

raise 'pq empty!!'
