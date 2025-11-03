f=->s{s[0]?s[0]-f[s.each_cons(2).map{_2-_1}]:0}
p$<.sum{f[_1.split.map &:to_i]}
