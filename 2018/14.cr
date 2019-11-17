input = "635041".chars.to_a.map(&.to_i)

e = 0
f = 1
recipes = [3_u8, 7_u8]

threshold = 8
loop do
  if recipes.size > threshold
    puts threshold
    match = (threshold/2..threshold).find { |i| recipes[i, input.size] == input }
    (puts match; exit) if match
    threshold *= 4
  end

  a, b = recipes[e].to_i, recipes[f].to_i
  sum = a + b
  if sum >= 10
    recipes << 1_u8 << (sum % 10).to_u8
  else
    recipes << sum.to_u8
  end

  e = (e + 1 + a) % recipes.size
  f = (f + 1 + b) % recipes.size
end
