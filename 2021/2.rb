require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

# lines = get_input_str_arr(__FILE__)
# groups = str_groups_separated_by_blank_lines(__FILE__)
# nums = get_single_line_input_int_arr(__FILE__)
# nums = get_multi_line_input_int_arr(__FILE__)


h=d=a=0
$<.map{
n=_1[-2..].to_i
_1[?f]?(h+=n;d+=a*n):a+=n*(_1[?d]?1:-1)}
p h*d
