lines = $stdin.read.strip.split("\n")

ops = lines.map { |line| line.match(/(\w+) (\w+) ?(-?.+)?/)[1..] }

qs = [[], []]
regs = [Hash.new(0), Hash.new(0)]
regs[0]['p'] = 0
regs[1]['p'] = 1
idxs = [0, 0]
blocked = [false, false]
terminated = [false, false]
sent = 0

[0, 1].cycle do |i|
  break if blocked.all? { |b| b == true } || terminated.all? { |b| b == true }
  next if terminated[i]
  reg = regs[i]
  op, x, y = ops[idxs[i]]
  y = y.match?(/\d+/) ? y.to_i : reg[y] if y
  p i
  p reg
  p ops[idxs[i]].join(' ')
  p qs[i]
  case op
  when 'snd'
    qs[(i + 1) % 2] << (x.match?(/\d+/) ? x.to_i : reg[x])
    sent += 1 if i == 1
  when 'set'
    reg[x] = y
  when 'add'
    reg[x] += y
  when 'mul'
    reg[x] *= y
  when 'mod'
    reg[x] %= y
  when 'rcv'
    if qs[i].empty?
      blocked[i] = true
    else
      reg[x] = qs[i].shift
      blocked[i] = false
    end
  when 'jgz'
    if (x.match?(/\d+/) ? x.to_i : reg[x]) > 0
      idxs[i] += y
      terminated[i] = true if idxs[i] < 0 || idxs[i] >= ops.size
      next
    end
  end
  unless blocked[i]
    idxs[i] += 1
    idxs[i] %= ops.size
  end
end

p 'done'
p sent
