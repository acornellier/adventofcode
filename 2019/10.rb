require_relative 'util'

grid = Grid.new(lines, 0, 0, nil)

h = {}

(0...lines.size).each do |y|
  (0...lines.size).each do |x|
    next unless grid[y][x] == '#'

    visible = 0
    (0...lines.size).each do |y2|
      (0...lines.size).each do |x2|
        next if y2 == y && x2 == x
        next unless grid[y2][x2] == '#'
        
        slope = x == x2 ? Float::INFINITY : (y - y2).to_f / (x - x2)
        y3 = y
        x3 = x
        bad = false
        loop do
          if slope == 0
            # no op
          else
            y3 += (y3 > y2 ? -1 : 1)
          end

          if slope == Float::INFINITY
            # no op
          elsif slope == 0
            x3 += (x3 > x2 ? -1 : 1)
          else
            x3 = (y3 - y2) / slope + x2
          end

          break if (y3 == y2 && x3 == x2) || bad
          bad = y3.round == y3 && x3.round == x3 && grid[y3][x3] == '#'
        end
        visible += 1 unless bad
      end
    end
    
    h[[y,x]] = visible
  end
end

station = h.max_by { |k, v| v }.first
station_y = station[0]
station_x = station[1]

hit = 0

loop do
  y = station_y
  x = station_x

  in_sight = []
  (0...lines.size).each do |y2|
    (0...lines.size).each do |x2|
      next if y2 == y && x2 == x
      next unless grid[y2][x2] == '#'

      slope = x == x2 ? Float::INFINITY : (y - y2).to_f / (x - x2)
      y3 = y
      x3 = x
      bad = false
      loop do
        if slope == 0
          # no op
        else
          y3 += (y3 > y2 ? -1 : 1)
        end

        if slope == Float::INFINITY
          # no op
        elsif slope == 0
          x3 += (x3 > x2 ? -1 : 1)
        else
          x3 = (y3 - y2) / slope + x2
        end

        break if (y3 == y2 && x3 == x2) || bad
        bad = y3.round == y3 && x3.round == x3 && grid[y3][x3] == '#'
      end

      in_sight << [y2, x2] unless bad
    end
  end

  raise '?' if in_sight.empty?
  
  halves = in_sight.partition do |y2, x2|
    x2 > x || x2 == x && y2 < y
  end.each do |half|
    half.sort_by! do |y2, x2|
      x == x2 ? -Float::INFINITY : (y - y2).to_f / (x - x2)
    end
  end

  p in_sight
  p halves.flatten(1)
  halves.flatten(1).each do |y2, x2|
    grid[y2][x2] = '.'
    hit += 1
    (p x2 * 100 + y2; exit) if hit == 200
  end
end
