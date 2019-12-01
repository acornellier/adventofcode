require_relative 'util'
lines = $stdin.read.chomp.split("\n")

'magic_missile, magic_missile, poison, recharge, shield, poison, magic_missile, magic_missile, magic_missile'
'poison, drain, recharge, poison, shield, recharge, poison, drain, magic_missile'

class Game
  attr_reader :hp, :mana, :boss, :shield_timer, :poison_timer, :recharge_timer, :spent_mana
  
  def initialize(hp, mana, boss, shield_timer, poison_timer, recharge_timer, spent_mana, spells = [])
    @hp = hp
    @mana = mana
    @boss = boss
    @shield_timer = shield_timer
    @poison_timer = poison_timer
    @recharge_timer = recharge_timer
    @spent_mana = spent_mana
    @spells = spells
  end

  def won?
    @boss <= 0 
  end
  
  def lost?
    @mana <= 0 || @hp <= 0 
  end
  
  def play(spell)
    # @hp -= 1
    # return if lost?
    apply_effects
    return if won?
    send(spell)
    @spells << spell
    return if won?
    apply_effects
    return if won?
    @hp -= @shield_timer >= 1 ? 1 : 8
  end
  
  def dup
    Game.new(@hp, @mana, @boss, @shield_timer, @poison_timer, @recharge_timer, @spent_mana, @spells.dup)
  end

  def draw
    puts "- Player #{@hp} HP, #{@mana} mana. Boss #{@boss} HP. Spent #{@spent_mana}."
    active_effects = [@shield_timer >= 1 ? 'shield' : nil, @poison_timer >= 1 ? 'poison' : nil, @recharge_timer >= 1 ? 'recharge' : nil].compact
    puts "- Active effects: #{active_effects.join(', ')}" unless active_effects.empty?
    puts "- Spells cast: #{@spells.join(', ')}"
    puts
  end
  
  def eql?(other)
    @hp == other.hp && @mana == other.mana && @boss == other.boss && @shield_timer == other.shield_timer && @poison_timer == other.poison_timer && @recharge_timer == other.recharge_timer && @spent_mana == other.spent_mana
  end
  
  def hash
    [@hp, @mana, @boss, @shield_timer, @poison_timer, @recharge_timer, @spent_mana].hash
  end
  
  private

  def magic_missile
    spend_mana(53)
    @boss -= 4
  end

  def drain
    spend_mana(73)
    @boss -= 2
    @hp += 2
  end

  def shield
    spend_mana(113)
    @shield_timer = 6
  end

  def poison
    spend_mana(173)
    @poison_timer = 6
  end

  def recharge
    spend_mana(229)
    @recharge_timer = 5
  end

  def spend_mana(mana)
    @mana -= mana
    @spent_mana += mana
  end

  def apply_effects
    @shield_timer -= 1 if @shield_timer >= 1
      
    if @poison_timer >= 1
      @poison_timer -= 1
      @boss -= 3
    end

    if @recharge_timer >= 1
      @recharge_timer -= 1
      @mana += 101
    end
  end
end

exit_condition = ->(game) { game.won? }
distance = ->(game) { game.spent_mana }

neighbors = ->(game) do
  [:magic_missile, :drain, :shield, :poison, :recharge].map do |spell|
    game.dup.tap { |g| g.play(spell) }
  end.reject(&:lost?)
end

game = Game.new(lines[0].to_i, lines[1].to_i, lines[2].to_i, 0, 0, 0, 0)
dijkstra(game, exit_condition, distance, neighbors)
