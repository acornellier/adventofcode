g=$<.read.split("\n\n")
a=g[1..].map{_1.split("\n").map{|l|l.split.map(&:to_i)}}
g[0].split(?,).map{|n|
n=n.to_i
a.reject!{|b|
b.map{_1.map!{|m|n==m ?0:m}}
w=[b,b.transpose].any?{|c|c.any?{_1.sum==0}}
p n*b.flatten.sum if !a[1]&&w
w}}