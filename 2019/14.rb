require_relative 'util'

rules = []
lines.each do |line|
  a, b = line.split(' => ')
  aa = a.split(', ').map { |aaa| x, y = aaa.split; [x.to_i, y] }
  x, y = b.split
  rules << [aa, [x.to_i, y]]
end

max_needed = Hash.new(0)
rules.each do |k, v|
  k.each do |n, el|
    max_needed[el] = n if n > max_needed[el]
  end
end

INITIAL_ORE = 100_000
initial_state = Hash.new(0)
initial_state['ORE'] = INITIAL_ORE

exit_condition = ->(state) { state.key?('FUEL') }

neighbors = ->(state) do
  rules.select do |k, (m, out_el)|
    state[out_el] <= max_needed[out_el] &&
      k.all? { |n, in_el| state[in_el] >= n }
  end.map do |k, (m, out_el)|
    state.dup.tap do |new|
      k.each do |n, ele|
        new[ele] -= n
      end
      new[out_el] += m
    end
  end
end

distance = ->(neighbor, _shortest_distance) do
  INITIAL_ORE - neighbor['ORE']
end

p dijkstra(initial_state, exit_condition, neighbors, distance)
