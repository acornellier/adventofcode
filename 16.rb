require 'pry'

lines = $<.readlines.map(&:strip)

class Sample
  attr_accessor :before, :inst, :after
  def initialize(before, inst, after)
    @before = before
    @inst = inst
    @after = after
  end
end

def addr(r, a, b, c) r[c] = r[a] + r[b] end
def addi(r, a, b, c) r[c] = r[a] + b end
def mulr(r, a, b, c) r[c] = r[a] * r[b] end
def muli(r, a, b, c) r[c] = r[a] * b end
def banr(r, a, b, c) r[c] = r[a] & r[b] end
def bani(r, a, b, c) r[c] = r[a] & b end
def borr(r, a, b, c) r[c] = r[a] | r[b] end
def bori(r, a, b, c) r[c] = r[a] | b end
def setr(r, a, b, c) r[c] = r[a] end
def seti(r, a, b, c) r[c] = a end
def gtir(r, a, b, c) r[c] = a > r[b] ? 1 : 0 end
def gtri(r, a, b, c) r[c] = r[a] > b ? 1 : 0 end
def gtrr(r, a, b, c) r[c] = r[a] > r[b] ? 1 : 0 end
def eqir(r, a, b, c) r[c] = a == r[b] ? 1 : 0 end
def eqri(r, a, b, c) r[c] = r[a] == b ? 1 : 0 end
def eqrr(r, a, b, c) r[c] = r[a] == r[b] ? 1 : 0 end

opcodes = (0..15).to_a
named_codes = [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]

samples = []
program = []
lines.each_slice(4).map do |slice|
  if slice[0].start_with? 'Before'
    samples << Sample.new(*slice[0..2].map { |line| line.scan(/\d+/).map(&:to_i) })
  else
    program += slice.map { |line| line.scan(/\d+/).map(&:to_i) }
  end
end

possible = opcodes.each_with_object({}) do |code, h|
  h[code] = named_codes
end

samples.each do |sample|
  possible[sample.inst[0]] &= named_codes.select do |code|
    r = sample.before.dup
    send(code, r, *sample.inst[1..-1])
    r == sample.after
  end
end

code_map = {}
until code_map.size == 16
  possible.each do |num, codes|
    next if code_map[num]
    codes.each do |code|
      next if possible.any? { |num2, code2| num2 != num && code2.include?(code) }
      possible[num] = [code]
      code_map[num] = code
      break
    end
  end
end

registers = [0] * 4
program.each do |prog|
  send(code_map[prog[0]], registers, *prog[1..-1])
end

puts registers.first
