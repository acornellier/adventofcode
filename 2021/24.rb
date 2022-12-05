require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

def make_default_vars
  { 'w' => 0, 'x' => 0, 'y' => 0, 'z' => 0 }
end

@vars = make_default_vars
@inputs = [1, 3]

def inp(a)
  @vars[a] = @inputs.shift
end

def set(a, b)
  @vars[a] = @vars[b] || b.to_i
end

def add(a, b)
  @vars[a] += @vars[b] || b.to_i
end

def mul(a, b)
  @vars[a] *= @vars[b] || b.to_i
end

def div(a, b)
  @vars[a] = (@vars[a] / (@vars[b] || b.to_i)).floor
end

def mod(a, b)
  @vars[a] = @vars[a] % (@vars[b] || b.to_i)
end

def eql(a, b)
  @vars[a] = @vars[a] == (@vars[b] || b.to_i) ? 1 : 0
end

def neql(a, b)
  @vars[a] = @vars[a] != (@vars[b] || b.to_i) ? 1 : 0
end

def op(a, b, c)
  digit = @vars['w'].to_i
  @vars['x'] = @vars['z'] % 26 + a.to_i == digit ? 0 : 1
  @vars['z'] /= b.to_i
  @vars['z'] *= 25 * @vars['x'] + 1
  @vars['z'] += (digit + c.to_i) * @vars['x']
end

def test_model(lines, model, print = false)
  @vars = make_default_vars
  @inputs = model.to_s.chars.map(&:to_i)
  lines.each do |line|
    send(*line.split(' ')) unless line.empty?
    p @vars if print
  end
  @vars
end

@test_models = (0...1000).map do
  (0...14).map { ('1'..'9').to_a.sample }.join.to_i
end

def test_a_bunch(lines)
  @test_models.map do |model|
    test_model(lines, model)
  end
end

def same_lines?(lines_1, lines_2)
  test_a_bunch(lines_1) == test_a_bunch(lines_2)
end

new_lines = lines.dup

Rule = Struct.new(:b_indexes, :replacement, :regexes)
rules = [
  Rule.new(
    [4, 3, 14],
    'op',
    [
      /mul x 0/,
      /add x z/,
      /mod x 26/,
      /div z (.+)/,
      /add x (.+)/,
      /eql x w/,
      /eql x 0/,
      /mul y 0/,
      /add y 25/,
      /mul y x/,
      /add y 1/,
      /mul z y/,
      /mul y 0/,
      /add y w/,
      /add y (.+)/,
      /mul y x/,
      /add z y/,
    ]
  ),
]

rules.each do |rule|
  idx = -1
  combo_size = rule.regexes.size
  loop do
    idx += 1
    ls = new_lines[idx, combo_size]
    break unless ls.size == combo_size

    matches = rule.regexes.map.with_index do |regex, index|
      ls[index].match(regex)
    end
    next unless matches.all?

    new_lines[idx] = rule.replacement
    rule.b_indexes.each do |b_index|
      new_lines[idx] += ' ' + matches[b_index][1]
    end

    (combo_size - 1).times do
      new_lines.delete_at(idx + 1)
    end

    # unless same_lines?(lines, new_lines)
    #   throw "not the same sadge"
    # end
  end
end

fancy_lines = new_lines.filter { _1.start_with?('op') }
File.write('24.input2', fancy_lines.join("\n"))

z = 0
inputs = ([9] * 14)
fancy_lines.each do |line|
  a, b, c = line.split[1..].map(&:to_i)
  digit = inputs.shift

  x = z % 26 + a == digit ? 0 : 1
  z /= b
  z *= 25 * x + 1
  z += (digit + c) * x
end

# test_model(lines, model, true)

# z % 26 + a == n
