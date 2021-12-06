require_relative 'util'
require_relative 'input'

# h=eval"[#{$<.read}].tally"
# 256.times{h=h.to_h{[_1-1,_2]}
# h[6]=(h[6]||0)+h[8]=h[-1]||0
# h[-1]=0}
# p h.values.sum

h=[0]*9
$<.read.split(?,).each{h[_1.to_i]+=1}
256.times{h=h[1,8].tap{_1[6]+=_1[8]=h[0]}}
p h.sum