require_relative 'util'
require_relative 'input'

ACTIVE = '#'
INACTIVE = '.'

def iterate(state)
  next_state = {}
  axes = state.keys.transpose
  axes.map! { |axis| ((axis.min - 1)..(axis.max + 1)).to_a }
  axes
    .first
    .product(*axes[1..]) do |pos|
      active_neighbors = neighbor_count(state, pos)
      if state[pos] && [2, 3].include?(active_neighbors) ||
           !state[pos] && active_neighbors == 3
        next_state[pos] = true
      end
    end
  next_state
end

$dirs = nil
def neighbor_count(state, pos)
  if !$dirs
    _dirs = [[0, -1, 1]] * state.keys.first.length
    $dirs = _dirs.first.product *_dirs[1..]
    $dirs.shift
  end
  $dirs.count { |dir| state[dir.zip(pos).map(&:sum)] }
end

state = {}
File
  .read('17.input')
  .split("\n")
  .each
  .with_index do |row, row_idx|
    row.chars.each.with_index do |c, col_idx|
      state[[row_idx, col_idx, 0, 0]] = c == ACTIVE
    end
  end

6.times do |n|
  p n
  state = iterate (state)
end
p state.values.count &:itself
