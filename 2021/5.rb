q=Hash.new 0
$<.map{a,b,c,d=_1.scan(/\d+/).map &:to_i
e=c<=>a
f=d<=>b
(q[[a,b]]+=1
a+=e
b+=f)until [a,b]==[c+e,d+f]}
p q.count{_2>1}
