require_relative 'util'
require_relative 'input'

h=[0]*9
gets.split(?,).map{h[_1.to_i]+=1}
256.times{h.rotate!
h[6]+=h[8]}
p h.sum