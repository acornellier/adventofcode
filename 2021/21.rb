play=->(a,b,c,d){d>=5?[0,1]:{3=>1,4=>3,5=>6,6=>7,7=>6,8=>3,9=>1}.map{|r,n|x=(a+r-1)%10+1
play[b,x,d,c+x].map{_1*n}}.transpose.map(&:sum).reverse}
p play[*$<.map{_1[28].to_i},0,0]