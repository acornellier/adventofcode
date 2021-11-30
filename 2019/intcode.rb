def intcode(code, infun, outfun)
  code = code.dup + [0] * 1000
  ps = 0
  done = false
  relative_base = 0

  until done
    modea = (code[ps] % 100_000) / 10_000
    modeb = (code[ps] % 10_000) / 1000
    modec = (code[ps] % 1000) / 100

    addr1 = modec == 2 ? code[ps + 1] + relative_base : code[ps + 1]
    val1 = modec == 1 ? addr1 : code[addr1]
    addr2 = modeb == 2 ? code[ps + 2] + relative_base : code[ps + 2]
    val2 = modeb == 1 ? addr2 : code[addr2]
    addr3 = modea == 2 ? code[ps + 3] + relative_base : code[ps + 3]

    case code[ps] % 100
    when 1
      code[addr3] = val1 + val2
      ps += 4
    when 2
      code[addr3] = val1 * val2
      ps += 4
    when 3
      code[addr1] = infun[]
      ps += 2
    when 4
      outfun[val1]
      ps += 2
    when 5
      (val1 != 0) ? (ps = val2) : ps += 3
    when 6
      (val1 == 0) ? (ps = val2) : ps += 3
    when 7
      code[addr3] = val1 < val2 ? 1 : 0
      ps += 4
    when 8
      code[addr3] = val1 == val2 ? 1 : 0
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
end
