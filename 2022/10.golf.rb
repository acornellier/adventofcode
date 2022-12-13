x=1
c=[]
$<.flat_map(&:split).map(&:to_i).map{c<<((-1..1)===c.size%40-x ??#:?.)
x+=_1}
c.each_slice(40){puts _1.join}
