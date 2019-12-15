require_relative 'util'
lines = $<.read.split("\n")

map = { ?R => RIGHT, ?U => UP, ?L => LEFT, ?D => DOWN }

g = Grid.new(nil, 0, 0, nil)
h = Grid.new(nil, 0, 0, nil)

g_vis = {}
h_vis = {}

l1 = lines[0].split(',')
l2 = lines[1].split(',')

g_steps = 1
h_steps = 1
l1.zip(l2).each do |a1, a2|
  (0...a1[1..].to_i).each do
    g.move(map[a1[0]])
    g_vis[[g.y, g.x]] ||= g_steps
    g_steps += 1
  end
  (0...a2[1..].to_i).each do
    h.move(map[a2[0]])
    h_vis[[h.y, h.x]] ||= h_steps
    h_steps += 1
  end
end

res = g_vis.keys.to_set.intersection(h_vis.keys.to_set).map do |y, x|
  g_vis[[y, x]] + h_vis[[y, x]]
end.min
