require "set"

WALL = '#'
OPEN = '.'
GOBLIN = 'G'
ELF = 'E'

class Square
  property :y, :x
  def initialize(y : Int32, x : Int32)
    @y = y
    @x = x
  end
  def ==(o)
    @y == o.y && @x == o.x
  end
  def eql?(o)
    @y == o.y && @x == o.x
  end
  def_hash @y, @x
end

class Unit
  property :side, :hp, :square
  def initialize(side : Char, y : Int32, x : Int32)
    @side = side
    @hp = 200
    @square = Square.new(y, x)
  end
  def alive?
    @hp > 0
  end
  def y
    @square.y
  end
  def x
    @square.x
  end
end

class Game
  def initialize(grid : Array(String), units : Array(Unit), elf_attack : Int32)
    @grid = grid
    @units = units
    @round = 0
    @elf_attack = elf_attack
    puts "elf attack: #{@elf_attack}"
  end

  def play!
    loop do
      puts "ROUND #{@round}"
      @grid.each { |line| puts line }

      break if @units.any? { |u| u.side == ELF && !u.alive? }
      @units = @units.select { |u| u.alive? }.sort_by { |a| [a.y, a.x] }
      (done!; break) if @units.all? { |u| u.side == GOBLIN } || @units.all? { |u| u.side == ELF }

      @units.each.with_index do |unit, i|
        next unless unit.alive?

        targets = @units.select { |u| unit.side != u.side && u.alive? }
        (done!; break) if targets.empty?
        next if attack?(unit, targets)

        in_range = targets.flat_map { |target| adjacent_squares(target) }
        reachable = in_range.select { |square| reachable?(unit.square, square) }
        next if reachable.empty?

        step = next_step(unit, reachable)
        raise "NO STEP" unless step
        @grid[unit.y] = @grid[unit.y].sub(unit.x, OPEN)
        @grid[step.y] = @grid[step.y].sub(step.x, unit.side)
        unit.square = step

        attack?(unit, targets)
      end
      @round += 1
    end
  end

  def next_step(unit, targets)
    last_layer = adjacent_squares(unit).each_with_object({} of Square => Set(Square)) do |square, h|
      h[square] = Set{square}
    end
    loop do
      reachable = last_layer.select { |s, r| targets.any? { |t| r.includes? t } }
      return reachable.keys.sort_by { |s| [s.y, s.x] }.first unless reachable.empty?

#      reached = [] of Square
      last_layer.each do |square, reached|
        last_layer[square] = reached.flat_map do |r|
          adjacent_squares(r)
        end.to_set
      end
    end
  end

  def adjacent_squares(unit, type = OPEN)
    squares = [] of Square
    squares << Square.new(unit.y + 1, unit.x) if @grid[unit.y + 1][unit.x] == type
    squares << Square.new(unit.y, unit.x - 1) if @grid[unit.y][unit.x - 1] == type
    squares << Square.new(unit.y, unit.x + 1) if @grid[unit.y][unit.x + 1] == type
    squares << Square.new(unit.y - 1, unit.x) if @grid[unit.y - 1][unit.x] == type
    squares.sort_by { |s| [s.y, s.x] }
  end

  def reachable?(square, target, reached = [] of Square)
    return 0 if square == target
    reached << square
    adjacent_squares(square).reject do |s|
      reached.includes? s
    end.any? do |s|
      reachable?(s, target, reached)
    end
  end

  def attack?(unit, targets)
    enemy_squares = adjacent_squares(unit, unit.side == ELF ? GOBLIN : ELF)
    return false if enemy_squares.empty?
    enemies = targets.select { |u| enemy_squares.includes? u.square }.sort_by { |u| [u.hp, u.y, u.x] }
    return false if enemies.empty?
    enemy = enemies.first
    damage = unit.side == ELF ? @elf_attack : 3
    enemy.hp -= damage
    @grid[enemy.y] = @grid[enemy.y].sub(enemy.x, OPEN) if enemy.hp <= 0
    true
  end

  def done!
    total_hp = @units.select { |unit| unit.alive? }.map(&.hp).sum
    puts "total hp: #{total_hp}"
    puts "Outcome: #{@round * total_hp}"
    exit if @units.all? { |unit| unit.side == ELF }
  end
end

(4..100).each do |power|
  grid = File.read_lines("../input.txt").map(&.strip)
  units = [] of Unit
  grid.each.with_index do |line, y|
    line.chars.each.with_index do |char, x|
      units << Unit.new(char, y, x) if [GOBLIN, ELF].includes? char
    end
  end
  Game.new(grid, units, power).play!
end
