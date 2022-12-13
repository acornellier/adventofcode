# copied this from someone's python solution

require 'set'

rope = [0i] * 10
seen = rope.map { Set[_1] }
dirs = { ?L => -1, ?R => 1, ?D => 1i, ?U => -1i }

$<.map(&:split).each do |dir, steps|
  steps.to_i.times do
    rope[0] += dirs[dir]
    1.upto(9) do |i|
      dist = rope[i - 1] - rope[i]
      rope[i] += (dist.real <=> 0) + (dist.imag <=> 0).i if dist.abs >= 2
      seen[i] << rope[i]
    end
  end
end

p [seen[1].size, seen[9].size]
