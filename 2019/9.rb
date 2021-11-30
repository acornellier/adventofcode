require_relative 'util'

a = lines[0].split(',').map(&:to_i) + [0] * 1000
ps = 0
done = false
relative_base = 0

until done
  opcode = a[ps] % 100
  modea = (a[ps] % 100_000) / 10_000
  modeb = (a[ps] % 10_000) / 1000
  modec = (a[ps] % 1000) / 100

  addr1 = modec == 2 ? a[ps + 1] + relative_base : a[ps + 1]
  val1 = modec == 1 ? addr1 : a[addr1]
  addr2 = modeb == 2 ? a[ps + 2] + relative_base : a[ps + 2]
  val2 = modeb == 1 ? addr2 : a[addr2]
  addr3 = modea == 2 ? a[ps + 3] + relative_base : a[ps + 3]

  case opcode
  when 1
    a[addr3] = val1 + val2
    ps += 4
  when 2
    a[addr3] = val1 * val2
    ps += 4
  when 3
    a[addr1] = 1
    ps += 2
  when 4
    p val1
    ps += 2
  when 5
    (val1 != 0) ? (ps = val2) : ps += 3
  when 6
    (val1 == 0) ? (ps = val2) : ps += 3
  when 7
    a[addr3] = val1 < val2 ? 1 : 0
    ps += 4
  when 8
    a[addr3] = val1 == val2 ? 1 : 0
    ps += 4
  when 9
    relative_base += val1
    ps += 2
  when 99
    done = true
  else
    raise '??'
  end
end
