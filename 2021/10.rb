t={?(=>?),?[=>?],?{=>?},?<=>?>}
x=$<.filter_map{|l|
s=[]
c=1
l.chop.chars{t[_1]?s<<_1:t[s[-1]]==_1 ?s.pop: c=nil}
f=0
s.reverse.map{f=5*f+' ([{<'.index(_1)}
c&&f}
p x.sort[x.size/2]