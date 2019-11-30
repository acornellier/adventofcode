require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

require 'set'

GENERATOR = 0
MICROCHIP = 1

class Item
  attr_accessor :ele, :type, :floor

  def initialize(ele, type, floor)
    @ele = ele
    @type = type
    @floor = floor
  end

  def dup
    Item.new(@ele, @type, @floor)
  end

  def to_s
    @ele[0].upcase + @type
  end

  def eql?(item)
    @ele == item.ele && @type == item.type && @floor == item.floor
  end

  def ==(item)
    eql?(item)
  end

  def hash
    [@ele, @type, @floor].hash
  end

  def same?(item)
    @ele == item.ele && @type == item.type
  end
end

og_items = []

lines.each.with_index(1) do |line, floor|
  line.scan(/(\w+)-compatible microchip/).flatten.each do |ele|
    og_items << Item.new(ele, MICROCHIP, floor)
  end
  line.scan(/(\w+) generator/).flatten.each do |ele|
    og_items << Item.new(ele, GENERATOR, floor)
  end
end

['elerium', 'dilithium'].each do |ele|
  [GENERATOR, MICROCHIP].each do |type|
    og_items << Item.new(ele, type, 1)
  end
end

states = Hash.new(Float::INFINITY)
initial_state = [1, og_items.map(&:dup)]
states[initial_state] = 0

visited = Set.new

start = Time.now
loop do
  shortest_distance = states.values.min
  cur = states.key(shortest_distance)
  elevator, items = cur

  if items.all? { |item| item.floor == 4 }
    puts shortest_distance
    p((Time.now - start) * 1000)
    exit
  end

  p [states.size, visited.size, shortest_distance] if states.size % 1000 == 0

  below_floors = (1...elevator).to_a
  below_empty = below_floors.empty? || items.none? { |item| below_floors.include?(item.floor) }
  possible_dists = (below_empty ? [+1] : elevator == 4 ? [-1] : [-1, +1])

  available = items.select { |item| item.floor == elevator }
  comb1 = available.combination(1).to_a
  comb2 = available.combination(2).to_a

  skip_1_up = false
  skip_2_down = false
  neighbors = possible_dists.each_with_object([]) do |dist, array|
    possible_takes = dist == +1 ? (comb2 + comb1) : (comb1 + comb2)
    possible_takes.each do |take|
      next if skip_1_up && dist == +1 && take.size == 1 || skip_2_down && dist == -1 && take.size == 2

      new_elevator = elevator + dist
      new_items = items.map(&:dup).each { |item| item.floor += dist if take.any? { |item2| item.same?(item2) } }

      chips, gens = new_items.select { |item| item.floor == new_elevator }.partition { |item| item.type == MICROCHIP }
      if !chips.any? { |chip| gens.any? { |gen| gen.ele != chip.ele } && gens.none? { |gen| gen.ele == chip.ele } }
        array << [new_elevator, new_items]
        skip_1_up = true if dist == +1 && take.size == 2
        skip_2_down = true if dist == -1 && take.size == 1
      end
    end
  end

  cur_dist = shortest_distance + 1
  neighbors.each do |neighbor|
    states[neighbor] = [states[neighbor] || Float::INFINITY, cur_dist].min unless visited.include?(neighbor)
  end
  visited.add(cur)
  states.delete(cur)
end
