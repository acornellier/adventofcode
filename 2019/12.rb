require_relative 'util'

og = lines.map { |line| line.scan(/-?\d+/).map(&:to_i) + [0, 0, 0] }

best = []
(0..2).each do |m|
  moons = og.map { |moon| [moon[m], moon[m + 3]] }
  visited = Set.new

  (0..).each do |n|
    moons
      .combination(2)
      .each do |a, b|
        if a[0] > b[0]
          a[1] -= 1
          b[1] += 1
        elsif a[0] < b[0]
          a[1] += 1
          b[1] -= 1
        end
      end

    moons.each { |moon| moon[0] += moon[1] }

    if visited.include?(moons)
      (
        p [n, moons]
        best << n
        break
      )
    end
    visited << moons
  end
end

p best.reduce(:lcm)
