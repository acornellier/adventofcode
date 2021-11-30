floating_address =
  (109_165..576_723).count do |n|
    s = n.to_s.chars

    l = [[s[0]]]
    s[1..].each { |c| c == l.last[0] ? l.last << c : l << [c] }

    l.any? { |ll| ll.size == 2 } && s == s.sort
  end

p floating_address
