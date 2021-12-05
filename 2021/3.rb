require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

o=$<.to_a
p([0, 1].map do |n|
l=o.dup
d=0
(t={0=>0,1=>0}.merge l.map{_1[d].to_i}.tally
c=t[0]==t[1]? n:t.sort_by{_2}[n][0]
l.select!{_1[d].to_i==c}
d+=1)until l.size==1
l[0].to_i(2)
end.inject :*)
