require 'pry'

class Instruction
  attr_accessor :code, :params
  def initialize(arr)
    @code = arr[0]
    @params = arr[1..-1]
  end
end

class Sample
  attr_accessor :before, :inst, :after
  def initialize(before, inst, after)
    @before = before
    @inst = Instruction.new(inst)
    @after = after
  end
end

INSTRUCTIONS = {
  addr: ->(r, a, b, c) { r[c] = r[a] + r[b] },
  addi: ->(r, a, b, c) { r[c] = r[a] + b },
  mulr: ->(r, a, b, c) { r[c] = r[a] * r[b] },
  muli: ->(r, a, b, c) { r[c] = r[a] * b },
  banr: ->(r, a, b, c) { r[c] = r[a] & r[b] },
  bani: ->(r, a, b, c) { r[c] = r[a] & b },
  borr: ->(r, a, b, c) { r[c] = r[a] | r[b] },
  bori: ->(r, a, b, c) { r[c] = r[a] | b },
  setr: ->(r, a, b, c) { r[c] = r[a] },
  seti: ->(r, a, b, c) { r[c] = a },
  gtir: ->(r, a, b, c) { r[c] = a > r[b] ? 1 : 0 },
  gtri: ->(r, a, b, c) { r[c] = r[a] > b ? 1 : 0 },
  gtrr: ->(r, a, b, c) { r[c] = r[a] > r[b] ? 1 : 0 },
  eqir: ->(r, a, b, c) { r[c] = a == r[b] ? 1 : 0 },
  eqri: ->(r, a, b, c) { r[c] = r[a] == b ? 1 : 0 },
  eqrr: ->(r, a, b, c) { r[c] = r[a] == r[b] ? 1 : 0 }
}

samples = []
program = []
$<
  .readlines
  .map(&:strip)
  .reject(&:empty?)
  .each_slice(3)
  .map do |slice|
    if slice[0].start_with? 'Before'
      samples << Sample.new(*slice.map { |line| line.scan(/\d+/).map(&:to_i) })
    else
      program +=
        slice.map { |line| Instruction.new(line.scan(/\d+/).map(&:to_i)) }
    end
  end

possible =
  (0..15).to_a.each_with_object({}) { |code, h| h[code] = INSTRUCTIONS.keys }

samples.each do |sample|
  possible[sample.inst.code] &=
    INSTRUCTIONS.select do |code, f|
      r = sample.before.dup
      f[r, *sample.inst.params]
      r == sample.after
    end.keys
end

code_map = {}
until code_map.size == 16
  possible.each do |num, codes|
    next if code_map[num]
    codes.each do |code|
      if possible.any? { |num2, code2| num2 != num && code2.include?(code) }
        next
      end
      possible[num] = [code]
      code_map[num] = code
    end
  end
end

registers = [0] * 4
program.each do |prog|
  INSTRUCTIONS[code_map[prog.code]][registers, *prog.params]
end

puts registers.first
