require_relative 'util'

code = lines[0].split(',').map(&:to_i)
outputs = []
intcode(code, -> { raise }, ->(val) { outputs << val })

grid = {}
outputs.each_slice(3) { |x, y, t| grid[[y, x]] = t }

find = ->(val) { grid.each { |(y, x), tile| return x if tile == val } }

infun = -> { (find[4] - find[3]).clamp(-1, 1) }

outputs = []
score = nil

outfun = ->(val) do
  outputs << val
  return unless outputs.size == 3
  x, y, t = *outputs
  outputs.clear
  if x == -1 && y == 0
    score = t
  else
    grid[[y, x]] = t
  end
end

code[0] = 2
intcode(code, infun, outfun)
p score
