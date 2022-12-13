require_relative 'util'
require_relative 'input'

lines = get_input_str_arr(__FILE__)

starts = []
ending = []
lines.each.with_index do |line, y|
  line.chars.each.with_index.each do |r, x|
    starts << [y, x] if r == 'S' || r == 'a'
    ending = [y, x] if r == 'E'
  end
end

steps = starts.map do |start|
  g = Grid.new(lines, *start)

  def to_ord(c)
    (c == 'S' ? 'a' : c == 'E' ? 'z' : c).ord
  end

  initial_state = g.coords

  exit_condition = ->(coords) { coords == ending }

  neighbors = ->(coords) do
    g.teleport(*coords)
    cur = to_ord(g.cur)
    g.bounded_neighbors.select do |coords2|
      (to_ord(g.at(*coords2)) - cur) <= 1
    end
  end

  dijkstra(initial_state, exit_condition, neighbors) rescue Float::INFINITY
end

p steps.min

