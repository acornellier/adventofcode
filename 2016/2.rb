require_relative 'util'
lines = $stdin.read.strip.split("\n")

keypad = [
  [nil, nil, 1, nil, nil],
  [nil, 2, 3, 4, nil],
  [5, 6, 7, 8, 9],
  [nil, 'A', 'B', 'C', nil],
  [nil, nil, 'D', nil, nil],
]

ship = Util.new(keypad, 2, 0, UP)

MAPPING = { 'U' => UP, 'L' => LEFT, 'R' => RIGHT, 'D' => DOWN }

lines.each do |line|
  line.each_char do |c|
    ship.move(MAPPING[c])
    ship.move(REVERSE[MAPPING[c]]) if ship.out_of_bounds? || ship.cur.nil?
  end
  puts ship.cur
end
