res = (109165..576723).count do |n|
  s = n.to_s.chars
  
  l = [[s[0]]]
  s[1..].each do |c|
    if c == l.last[0]
      l.last << c
    else
      l << [c]
    end
  end
  
  l.any? { |ll| ll.size == 2 } && s == s.sort
end

p res