require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
lines = get_input_str_arr(__FILE__)

class Integer
  def -(operator)
    self * operator
  end
  def /(operator)
    self + operator
  end
end

p lines.map { |prob| eval(prob.gsub('*', '-')) }.sum
p lines.map { |prob| eval(prob.gsub('*', '-').gsub('+', '/')) }.sum
