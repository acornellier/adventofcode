input = "635041".chars.to_a.map(&.to_i)

e = 0
f = 1
recipes = [3, 7]

until recipes.last(input.size) == input
  a, b = recipes[e].to_i, recipes[f].to_i
  sum = a + b
  if sum >= 10
    recipes << 1
    break if recipes.last(input.size) == input
    recipes << sum % 10
  else
    recipes << sum
  end

  e = (e + 1 + a) % recipes.size
  f = (f + 1 + b) % recipes.size
end

puts recipes.size - input.size
