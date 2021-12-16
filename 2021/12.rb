require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)
# nums = get_single_line_input_int_arr(__FILE__)
# nums = get_multi_line_input_int_arr(__FILE__)

h = {}
lines.each do |line|
  a, b = line.split('-')
  h[a] ||= []
  h[a] << b

  h[b] ||= []
  h[b] << a
end

h.transform_values(&:uniq)

paths = []
path_count = ->(cur, path, twice_done) do
  return 0 if %w[start end].include?(cur) && path.include?(cur)

  if cur == cur.downcase && path.include?(cur)
    return 0 if twice_done
    twice_done = true
  end

  path << cur

  return 1 if cur == 'end'

  (h[cur] || []).sort.sum { |neighbor| path_count.call(neighbor, path.dup, twice_done) }
end

puts path_count.call('start', [], false)
