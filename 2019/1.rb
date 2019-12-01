f=->m{n=m/3-2;n<0?0:n+f[n]}
p $<.sum{|l|f[l.to_i]}