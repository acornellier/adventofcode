require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

keypad = [
  [nil, nil, 1, nil, nil],
  [nil, 2, 3, 4, nil],
  [5, 6, 7, 8, 9],
  [nil, ?A, ?B, ?C, nil],
  [nil, nil, ?D, nil, nil],
]

g = Grid.new(keypad, 2, 0, UP)

MAPPING = { ?U => UP, ?L => LEFT, ?R => RIGHT, ?D => DOWN }

lines.each do |line|
  line.each_char do |c|
    g.move(MAPPING[c])
    g.move(REVERSE[MAPPING[c]]) if g.out_of_bounds? || g.cur.nil?
  end
  puts g.cur
end
