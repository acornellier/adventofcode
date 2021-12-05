lines = $stdin.read.chomp.split("\n")

class Point
  attr_accessor :p, :v, :a
  def initialize(p, v, a)
    @p = p
    @v = v
    @a = a
  end

  def update!
    (0..2).each do |i|
      @v[i] += @a[i]
      @p[i] += @v[i]
    end
  end

  def dist
    @p.sum { |n| n**2 }
  end
end

p = []
lines.each do |line|
  p <<
    Point.new(*line.scan(/(-?\d+),(-?\d+),(-?\d+)/).map { |l| l.map(&:to_i) })
end

# distances = Array.new(points.size, 0)
1_000.times do |n|
  p p.size
  p.each.with_index do |point, idx|
    point.update!
    # distances[idx] += point.dist
  end

  indexes_to_delete = []
  p.each.with_index do |point, idx|
    ((idx + 1)...(p.size)).each do |idx2|
      indexes_to_delete << idx << idx2 if point.p == p[idx2].p
    end
  end

  indexes_to_delete.uniq.sort.reverse.each { |idx| p.delete_at(idx) }
end

# p distances.map { |d| d / 100000 }
# puts distances.index(distances.min)
p p.size
