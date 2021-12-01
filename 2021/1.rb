require_relative 'util'
require_relative 'input'

p $<.map(&:to_i).each_cons(4).count{_1[0]<_1[3]}
