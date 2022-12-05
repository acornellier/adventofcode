p($<.map(&:split).sum { |a, b|
  if b == ?Y
    3 + a.ord - ?@.ord
  elsif b == ?X
    (a.ord - 66) % 3 + 1
  else
    6 + (a.ord - 67) % 3 + 1
  end
})

p($<.map(&:split).sum { |a, b|
  b == ?Y ? 3 + a.ord - ?@.ord : b == ?X ? (a.ord - 66) % 3 + 1 : 6 + (a.ord - 67) % 3 + 1
})


