m=$<.map{x=_1.scan /\d+/
(x[1,5]&x[6..]).size}
c=[1]*m.size
m.each_index{|i|1.upto(m[i]){c[i+_1]+=c[i]}}
p c.sum