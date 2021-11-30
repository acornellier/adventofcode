f = ->(m) do
  n = m / 3 - 2
  n < 0 ? 0 : n + f[n]
end
p $<.sum { |l| f[l.to_i] }
