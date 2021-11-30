require_relative 'util'
lines = $stdin.read.strip.split("\n")

def decompress(data)
  i = 0
  size = 0
  until i >= data.size
    c = data[i]
    case c
    when '('
      s, x, y = data[i + 1..].match(/(\d+)x(\d+)/).to_a
      i += s.size + 2
      size += decompress(data[i...i + x.to_i]) * y.to_i
      i += x.to_i
    else
      size += 1
      i += 1
    end
  end
  size
end

data = lines[0]
# data = '(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN'
decomp = decompress(data)

# puts decomp
puts decomp
