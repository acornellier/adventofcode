require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)
# @type [Array<Array<String>>]
# groups = str_groups_separated_by_blank_lines(__FILE__)

seqs = lines.map { _1.split.map(&:to_i) }

def next_val(seq)
  return 0 if seq.all?(&:zero?)

  diffs = seq.each_cons(2).map { _2 - _1 }
  val = next_val(diffs)
  seq.last + val
end

def prev_val(seq)
  return 0 if seq.all?(&:zero?)

  diffs = seq.each_cons(2).map { _2 - _1 }
  val = prev_val(diffs)
  seq.first - val
end

res = seqs.sum do |seq|
  next_val(seq)
end

p res

res = seqs.sum do |seq|
  prev_val(seq)
end

p res
