d,*q={0=>x=0}
$_[1..-2].chars.map{|c|eval'q<<x x=q.pop *q,x=q o=x;x+=1i**"ESWN".index(c);d[x]=[d[x]||1e9,d[o]+1].min'.split['()|'.index(c)||3]}
p d.values.max,d.count{|_,f|f>999}