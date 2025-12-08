p$<.sum{|s|12.downto(1){d=s.strip.chars[..-_1].max
s=s[1+s.index(d)..]
d}.join.to_i}