require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)

GOOD = '.'
BAD = '#'
UNKNOWN = '?'

def perms(springs, spring_idx, cur_spring, groups, group_idx, cur_group, is_chain, memo)
  key = [spring_idx, cur_spring, group_idx, cur_group, is_chain].hash
  return memo[key] if memo.has_key?(key)

  if cur_group&.negative?
    memo[key] = 0
    return 0
  end

  case cur_spring
  when nil
    group_idx >= groups.size || (group_idx == groups.size - 1 && cur_group == 0) ? 1 : 0
  when BAD
    if is_chain
      return 0 if cur_group > 0
      group_idx += 1
      cur_group = groups[group_idx]
    end
    memo[key] = perms(springs, spring_idx + 1, springs[spring_idx], groups, group_idx, cur_group, false, memo)
  when GOOD
    return 0 if group_idx >= groups.size

    memo[key] = perms(springs, spring_idx + 1, springs[spring_idx], groups, group_idx, cur_group - 1, true, memo)
  else
    good = perms(springs, spring_idx, GOOD, groups, group_idx, cur_group, is_chain, memo)
    bad = perms(springs, spring_idx, BAD, groups, group_idx, cur_group, is_chain, memo)
    memo[key] = good + bad
  end
end

mult = 5

s = Time.now
res = lines.map do |line|
  springs, groups = line.split
  springs = ([springs] * mult).join('?')
  groups = groups.split(',').map(&:to_i) * mult
  perms(springs, 1, springs[0], groups, 0, groups[0] || -1, false, {})
end
p Time.now - s
# p res
p res.sum
