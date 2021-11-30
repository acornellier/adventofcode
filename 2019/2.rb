require_relative 'util'
lines = $<.read.split("\n")

(0..99).each do |x|
  (0..99).each do |y|
    codes = lines[0].split(',').map(&:to_i)
    codes[1] = x
    codes[2] = y

    idx = 0
    loop do
      e = true
      a, b, c, d = codes[idx..idx + 3]
      case a
      when 1
        codes[d] = codes[b] + codes[c]
      when 2
        codes[d] = codes[b] * codes[c]
      when 99
        if codes[0] == 19_690_720
          p codes
          p x, y
          p 100 * x + y
          exit
        end
        e = false
      else
        raise '??'
      end
      break unless e
      idx += 4
    end
  end
end
