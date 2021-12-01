require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
rules, messages = str_groups_separated_by_blank_lines(__FILE__)

@rules =
  rules.to_h do |rule|
    id, details = rule.split(': ')
    match =
      if details.start_with?('"')
        details[1..-2]
      else
        details.split(' | ').map { |nums| nums.split(' ').map(&:to_i) }
      end
    [id.to_i, match]
  end

def remaining_chars_options(chars, rule)
  options = []
  if rule.is_a?(String)
    options = [chars[1..]] if chars[0] == rule
  else
    rule.each do |sub_rule|
      sub_options = [chars.dup]
      sub_rule.each do |rule_id|
        sub_options =
          sub_options.flat_map do |option|
            remaining_chars_options(option, @rules[rule_id])
          end
      end
      options += sub_options
    end
  end
  options
end

def matches?(message, rule)
  remaining_chars_options(message.chars, rule).any? { |option| option.empty? }
end

puts (
       messages.count do |message|
         matches?(message, @rules[0]).tap { |yes| p [message, yes] }
       end
     )
