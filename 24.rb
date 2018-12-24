lines = File.readlines('../input.txt').map(&:strip)
# lines = File.readlines('example.txt').map(&:strip)

class Group
  attr_accessor :id, :side, :size, :hp, :ad, :at, :it, :wk, :im
  def initialize(id, side, size, hp, ad, at, it, wk, im)
    @id = id
    @side = side
    @size = size
    @hp = hp
    @ad = ad
    @at = at
    @it = it
    @wk = wk
    @im = im
  end

  def ef
    @size * @ad
  end

  def attack(dmg)
    @size -= dmg / @hp
  end

  def alive?
    @size > 0
  end
end

def damage(a, b)
  return 0 if b.im.include?(a.at)
  d = a.ef
  d *= 2 if b.wk.include?(a.at)
  d
end

a = true
og = lines[1..-1].map.with_index do |l, id|
  (a = false; next) if l.include? 'Infection'
  side = a ? ?a : ?b
  size, hp, ad, it = l.scan(/\d+/).map(&:to_i)
  at = l.scan(/(\w+) damage/).first.first
  wk = []
  im = []
  stuff = l.scan(/\((.*)\)/).first
  if stuff
    stuff.first.split('; ').each do |s|
      types = s.scan(/.* to (.*)/).first.first.split(', ')
      s.include?('weak to') ? wk += types : im += types
    end
  end
  Group.new(id, side, size, hp, ad, at, it, wk ,im)
end.compact

0.upto(Float::INFINITY) do |boost|
  p boost
  groups = og.map { |g| g.dup }
  groups.each { |g| g.ad = g.ad + boost if g.side == ?a }

  until [?a, ?b].any? { |side| groups.all? { |u| u.side == side } }
    targets = {}
    groups.sort_by { |g| [g.ef, g.it] }.reverse.each do |g|
      best = [nil, 0]
      groups.each do |f|
        next if g.side == f.side
        dmg = damage(g, f)
        b = best[0]
        if dmg > best[1] || b && ((dmg == best[1] && f.ef > b.ef) || (dmg == best[1] && f.ef == b.ef && f.it > b.it))
          best = [f, dmg] unless targets.values.map(&:id).include?(f.id)
        end
      end
      targets[g.id] = best[0] if best[0]
    end

    break if targets.empty?
    groups.sort_by(&:it).reverse.each do |g|
      t = targets[g.id]
      next unless t && g.alive? && t.alive?
      t.attack(damage(g, t))
    end

    groups.select!(&:alive?)
  end

  if groups.all? { |u| u.side == ?a }
    p groups.sum(&:size)
    exit
  end
end
