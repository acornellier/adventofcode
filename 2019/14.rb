require_relative 'util'

rules =
  lines.to_h do |line|
    a, b = line.split(' => ')
    aa =
      a
        .split(', ')
        .map do |aaa|
          x, y = aaa.split
          [y, x.to_f]
        end
    x, y = b.split
    [[y, x.to_f], aa]
  end

STARTING_ORE = 1e12
need = Hash.new(0)
need['FUEL'] = 1
have = Hash.new(0)
have['ORE'] = STARTING_ORE

def make_fuel(rules, need, have)
  until need.empty?
    need_ele, need_n = need.shift
    (rule_out_ele, rule_out_n), rule_in =
      rules.find { |(out_ele, out_n), input| out_ele == need_ele }

    num = (need_n.to_f / rule_out_n).ceil
    rule_in.each do |in_ele, n|
      qty = n * num
      stored = have[in_ele]
      if qty <= stored
        have[in_ele] -= qty
      else
        have.delete(in_ele)
        need[in_ele] += qty - stored
      end
    end

    break if have['ORE'] <= 0

    need.delete(need_ele)
    have[need_ele] += num * rule_out_n - need_n
    have.select! { |have_ele, have_n| have_n > 0 }
  end
end

make_fuel(rules, need, have)
p STARTING_ORE - have['ORE']

need = Hash.new(0)
have = Hash.new(0)
have['ORE'] = STARTING_ORE
fuel = 0

12
  .downto(0)
  .each do |power|
    batch = 10**power

    loop do
      need['FUEL'] = batch
      need_backup = need.dup
      have_backup = have.dup

      make_fuel(rules, need, have)

      if have['ORE'] > 0
        fuel += batch
      else
        need = need_backup
        have = have_backup
        break
      end
    end
  end

p fuel
