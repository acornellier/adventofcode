lines = $stdin.read.chomp.split("\n")

def newa(n)
  Array.new(n) { ' ' * n }
end

def rotate1(t)
  u = newa(t.size)
  (0...t.size).each do |y|
    (0...t.size).each do |x|
      u[y][x] = t[t.size - x - 1][y]
    end
  end
  u
end

def rotate2(t)
  u = newa(t.size)
  (0...t.size).each do |y|
    (0...t.size).each do |x|
      u[y][x] = t[t.size - y - 1][t.size - x - 1]
    end
  end
  u
end

def rotate3(t)
  u = newa(t.size)
  (0...t.size).each do |y|
    (0...t.size).each do |x|
      u[y][x] = t[x][t.size - y - 1]
    end
  end
  u
end

def flipx(t)
  u = newa(t.size)
  (0...t.size).each do |y|
    u[y] = t[t.size - y - 1]
  end
  u
end

def flipy(t)
  u = newa(t.size)
  (0...t.size).each do |y|
    (0...t.size).each do |x|
      u[y][x] = t[y][t.size - x - 1]
    end
  end
  u
end

def perms2(t)
  [rotate1(t), rotate2(t), rotate3(t)]
end

def permutations(t)
  [t, *perms2(t), *perms2(flipx(t)), *perms2(flipy(t))].uniq
end

rules = {}
lines.each do |line|
  a, b = line.match(/(.*) => (.*)/)[1..]
  permutations(a.split('/')).each do |p|
    rules[p] = b.split('/')
  end
end

grid = [
 '.#.',
 '..#',
 '###',
]

times = 0
loop do
  n = grid.size.even? ? 2 : 3
  new_grid = []
  (0...(grid.size / n)).each do |y|
    (0...(grid.size / n)).each do |x|
      subset = grid[(n * y)..(n * y + n - 1)].map { |r| r[(n * x)..(n * x + n - 1)] }
      match = rules[subset]
      match.each.with_index do |r, i|
        if x == 0
          new_grid << r
        else
          new_grid[(n + 1) * y + i] += r
        end
      end
    end
  end
  grid = new_grid
  times += 1

  grid.each { |r| puts r }
  puts
  break if times == 18
end

p grid.sum { |r| r.count('#') }
