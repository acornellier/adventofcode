require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

columns = lines.map { _1.split }.transpose
res = columns.map do |column|
  [column[0..-2].map(&:to_i), column[-1]]
end
             .sum do
  _1.inject(_2)
end
p "part 1: #{res}"

start_idx = 0
res = columns.map do |column|
  column.max_by(&:size).size
end.sum do |digits|
  res2 = (0...digits).map do |i|
    lines.map { _1[start_idx + i] }.join.to_i
  end.inject(lines[-1][start_idx])
  start_idx += digits + 1
  res2
end
p "part 2: #{res}"
